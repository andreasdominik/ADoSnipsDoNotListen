#
# API function goes here, to be called by the
# skill-actions:
#

TOPIC_NOTIFICATION_ON="hermes/feedback/sound/toggleOn"
TOPIC_NOTIFICATION_OFF="hermes/feedback/sound/toggleOff"

TOPIC_NLU_INTENT_FILTER="hermes/dialogueManager/configure"
TOPIC_NLU_RESET_INTENT_FILTER="hermes/dialogueManager/configureReset"


function stopListening(siteId)

    intents = gatherIntents()
    Snips.printDebug("intents: $intents")

    # disable all intents explicitly.
    # make payload with all intents:
    #
    topic = TOPIC_NLU_INTENT_FILTER
    intentsList = [Dict(:intentId => intent, :enable => false) for intent in intents]

    payload = Dict(:siteId => siteId,
                   :intents => intentsList)
    # Snips.printDebug("payload: $payload")
    Snips.publishMQTT(topic, payload)

    payload[:intents] = [Dict(:intentId => INTENT_LISTEN_AGAIN, :enable => true)]
    Snips.publishMQTT(topic, payload)

    # turn off sounds:
    #
    Snips.publishMQTT(TOPIC_NOTIFICATION_OFF, Dict(:siteId => siteId))
end



function resetListening(siteId)

    topic = TOPIC_NLU_RESET_INTENT_FILTER
    payload = Dict(:siteId => siteId,
                   :intents => [])
    Snips.publishMQTT(topic, payload)

    payload[:intents] = [Dict(:intentId => INTENT_LISTEN_AGAIN, :enable => false)]
    Snips.publishMQTT(topic, payload)

    # turn off sounds:
    #
    Snips.publishMQTT(TOPIC_NOTIFICATION_ON, Dict(:siteId => siteId))
end


"""
takes all config.ini lines with intents_<something>:
and makes one big list of Strings.
"""
function gatherIntents()

    rgx = Regex("^intents_")
    config = filter(p->occursin(rgx, String(p.first)), Snips.getAllConfig())

    intents = String[]
    for one in keys(config)
        if config[one] isa AbstractString
            push!(intents, config[one])
        else
            append!(intents, config[one])
        end
    end
    return intents
end


function startStopHotword(siteId, startStop)


    if startStop == :off
        topic = "susi/dialogueManager/stopListen"
    else
        topic = "susi/dialogueManager/startListen"
    end

    payload = Dict(:siteId=>siteId,
                   :sessionId=>"no_session")

    publishMQTT(topic, payload)
end

function getConfigMode()

    mode = Snips.getConfig(INI_MODE)
    if mode == nothing
        mode = MODE_HOTWORD
    end
    return mode
end
