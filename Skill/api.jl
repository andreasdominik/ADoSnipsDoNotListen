#
# API function goes here, to be called by the
# skill-actions:
#

function stopStartListening(;mode = :stop)

    if mode == :stop
        enable = false
        toggle = "toggleOff"
    else
        enable = true
        toggle = "toggleOn"
    end

    intents = gatherIntents()

    Snips.printDebug("intents: $intents")

    # disable all intents explicitly.
    # make payload with all intents:
    #
    topic = "hermes/dialogueManager/configure"
    intentsList = [Dict(:intentId => intent, :enable => enable) for intent in intents]

    payload = Dict(:siteId => Snips.getSiteId(),
                   :intents => intentsList)
    Snips.printDebug("payload: $payload")

    Snips.publishMQTT(topic, payload)

    # enable listen-again:
    #
    payload[:intents] = [Dict(:intentId => INTENT_LISTEN_AGAIN, :enable => !enable)]
    Snips.publishMQTT(topic, payload)

    # turn off sounds:
    #
    Snips.publishMQTT("hermes/feedback/sound/$toggle", Dict(:siteId => Snips.getSiteId()))
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
