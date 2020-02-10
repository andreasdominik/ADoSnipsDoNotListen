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
    Snips.printLog("action stopListenAction() started.")

    stopStartListening(mode = :stop)
    Snips.publishEndSession(:stop_listening)
    return false   # no command afterwards
end




"""
function startListenAction(topic, payload)

    Start listening
"""
function startListenAction(topic, payload)

    # log:
    Snips.printLog("action startListenAction() started.")

    stopStartListening(mode = :start)
    Snips.publishEndSession(:start_listening)

    # normally we want to say a command afterwards!
    #
    return true
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
        "command" : "stop"   // or "start"
      }
    }
"""
function triggerListenAction(topic, payload)

    Snips.printLog("action triggerListenAction() started.")

    # test if trigger is complete:
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
