#
# API function goes here, to be called by the
# skill-actions:
#

function stopStartListening(;mode = :stop)

    if mode == stop
        enable = false
        toggle = "toggleOff"
    else
        enable = true
        toggle = "toggleOn"
    end

    intents = gatherIntents()

    # disable all intents explicitly.
    # make payload with all intents:
    #
    topic = "hermes/dialogueManager/configure"
    intentsList = [Dict(:intentId => intent, :enable => enable) for intent in intents]

    payload = Dict(:siteId => Snips.getSiteId(),
                   :intents => intentList)
    publishMQTT(topic, payload)

    # enable listen-again:
    #
    payload[:intents] = [Dict(:intentId => INTENT_LISTEN_AGAIN, :enable => !enable)]
    publishMQTT(topic, payload)

    # turn off sounds:
    #
    publishMQTT("hermes/feedback/sound/$toggle", Dict(:siteId => Snips.getSiteId()))
end


"""
takes all config.ini lines with intents_<something>:
and makes one big list of Strings.
"""
function gatherIntents()

    rgx = Regex("^intents_:")
    config = filter(p->occursin(rgx, String(p.first)), getAllConfig())

    intents = String[]
    for one in keys(config)
        append!(intents, config[one])
    end
    return intents
end
