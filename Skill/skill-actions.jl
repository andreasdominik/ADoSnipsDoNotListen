#
# actions called by the main callback()
# provide one function for each intent, defined in the Snips Console.
#
# ... and link the function with the intent name as shown in config.jl
#
# The functions will be called by the main callback function with
# 2 arguments:
# * MQTT-Topic as String
# * MQTT-Payload (The JSON part) as a nested dictionary, with all keys
#   as Symbols (Julia-style)
#
"""
function stopListenAction(topic, payload)

    Stop listening
"""
function stopListenAction(topic, payload)

    # log:
    println("[stopListenAction]: action stopListenAction() started.")

    # doublecheck command:
    #
    if !occursin(REGEX_STOP, payload[:input])
        println("[stopListenAction]: Aborted because of false activation!")
        Snips.publishEndSession("")
        return false
    end

    stopStartListening(mode = :stop)
    Snips.publishEndSession(:stop_listening)
    return true
end




"""
function startListenAction(topic, payload)

    Start listening
"""
function startListenAction(topic, payload)

    # log:
    println("[startListenAction]: action startListenAction() started.")

    # doublecheck command:
    #
    if !occursin(REGEX_START, payload[:input])
        println("[startListenAction]: Aborted because of false activation!")
        Snips.publishEndSession("")
        return false
    end

    stopStartListening(mode = :start)
    Snips.publishEndSession(:start_listening)
    return false
end


#
# TRIGGER:
#

"""
    triggerListenAction(topic, payload)

The trigger must have the following JSON format:
    {
      "target" : "qnd/trigger/andreasdominik:ADoSnipsListen",
      "origin" : "ADoSnipsScheduler",
      "sessionId": "1234567890abcdef",
      "siteId" : "default",
      "time" : "timeString",
      "trigger" : {
        "room" : "default",
        "command" : "stop"   // or "start"
      }
    }
"""
function triggerListenAction(topic, payload)

    println("[ADoSnipsDoNotListen]: action triggerListenAction() started.")

    # text if trigger is complete:
    #
    payload isa Dict || return false
    haskey( payload, :trigger) || return false
    trigger = payload[:trigger]

    #haskey(trigger, :room) || return false

    haskey(trigger, :command) || return false
    trigger[:command] in ["stop", "start"] || return false
    command = Symbol(trigger[:command])

    stopStartListening(mode = command)
    if command == :stop
        Snips.publishSay(:stop_listening)
    else
        Snips.publishSay(:start_listening)
    end

    return false
end
