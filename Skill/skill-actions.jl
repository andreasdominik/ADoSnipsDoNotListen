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
    if !occursin(r"^(?bitte |)hör. (?weg|nicht mehr zu)$"i, payload[:input])
        println("[stopListenAction]: Aborted because of false activation!")
        Snips.publishEndSession("")
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
    if !occursin(r"^(?bitte |)hör. (?wieder |)zu$"i, payload[:input])
        println("[startListenAction]: Aborted because of false activation!")
        Snips.publishEndSession("")
    end

    stopStartListening(moder = :start)
    Snips.publishEndSession(:start_listening)
    return true
end
