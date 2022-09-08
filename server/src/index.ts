import {WebSocketServer, WebSocket} from 'ws'
import * as dotenv from 'dotenv'
import {cleanEnv, port} from 'envalid'
import {customAlphabet} from 'nanoid'
import {omit} from 'lodash-es'
import assert from "assert";

dotenv.config()
const env = cleanEnv(process.env, {
    PORT: port({default: 3000}),
})

const generateCode = customAlphabet('123456789abcdefghijklmnpqrstuvzxyw', 4)

const wss = new WebSocketServer({port: env.PORT});

let groups: {
    [groupId: string]: {
        [uid: string]: WebSocket
    }
} = {}

type SDP = {
    to: string,
    from: string,
    sdp: any
}

const createEvent = (event: string, payload?: any): string => {
    if (payload) {
        return JSON.stringify([event, payload])
    }
    return JSON.stringify([event])
}

const parseEvent = (data: string): {
    event: string,
    payload?: any
} => {
    const arr = JSON.parse(data);
    if (!Array.isArray(arr)) {
        throw new Error("Malformed event, underlying data should be an array")
    }
    if (arr.length === 0) {
        throw new Error(`Malformed event, underlying array is empty`)
    }
    if (arr.length > 2) {
        throw new Error(`Malformed event, unsupported length of ${data.length}`)
    }
    // data is now array of size 1 or 2
    const event = arr.shift()
    let payload = arr.length > 0 ? arr.shift() : undefined
    return {
        event,
        payload
    }
}

wss.on('connection', ws => {
    const userId = generateCode()
    let roomId: string | null = null

    const create = () => {
        if (userId !== roomId) {
            groups[userId] = {}
            join(userId)
        }
    }

    const join = (requestedRoomId: string) => {
        if (groups[requestedRoomId]) {
            if (roomId !== requestedRoomId) {
                groups[requestedRoomId] = {
                    ...groups[requestedRoomId],
                    [userId]: ws
                }
                roomId = requestedRoomId
                ws.send(createEvent('joined', roomId))
                Object.keys(groups[requestedRoomId]).forEach(memberId => {
                    if (memberId !== userId) {
                        // Notify member, that this user has joined
                        console.log(`Notify member ${memberId}, that this user ${userId} has joined`)
                        groups[requestedRoomId][memberId].send(createEvent('user-added', userId))
                    }
                    // Notify this user about the existing member
                    console.log(`Notify this user ${userId} about the existing member`)
                    ws.send(createEvent('user-added', memberId))
                })
                console.log(`[${userId}] joined ${requestedRoomId}`)
            } else {
                console.warn(`[${userId}] cannot join, already inside ${requestedRoomId}`)
            }
        } else {
            console.warn(`[${userId}] cannot join, ${requestedRoomId} not found`)
        }
    }

    const leave = () => {
        if (roomId !== null) {
            const formerGroupId = roomId
            groups[formerGroupId] = omit(groups[formerGroupId], userId)
            roomId = null
            Object.keys(groups[formerGroupId]).forEach(memberId => {
                groups[formerGroupId][memberId].send(createEvent('user-removed', userId))
                ws.send(createEvent('user-removed', memberId))
            })
            ws.send(createEvent('left', formerGroupId))
            if (Object.keys(groups[formerGroupId]).length === 0) {
                // Remove empty group
                groups = omit(groups, formerGroupId)
            }
            console.log(`[${userId}] left ${formerGroupId}`)
        }
    }

    ws.on('message', (data: string) => {
        try {
            const event = parseEvent(data)
            if (event) {
                console.log(event.event)
                switch (event.event) {
                    case "join": {
                        if (typeof event.payload == "string")
                            join(event.payload);
                        break;
                    }
                    case "leave": {
                        leave();
                        break;
                    }
                    case "create": {
                        create();
                        break;
                    }
                    case "sdp": {
                        // Send to target user
                        if (roomId) {
                            const data: SDP = event.payload;
                            if (typeof event.payload == "object" && data.to && data.from && data.sdp) {
                                assert(groups[roomId] !== undefined)
                                // Get target user from current group
                                if (groups[roomId][data.to]) {
                                    ws.send(createEvent('sdp', data))
                                }
                            }
                        }
                        break;
                    }
                }
            }
        } catch (e) {
            console.error(e)
        }
    })

    ws.on('close', () => {
        leave()
        console.log(`[${userId}] disconnected`)
    })

    console.log(`[${userId}] connected`)

    ws.send(createEvent('uid', userId))
});

console.info("Server running at port %d", env.PORT)