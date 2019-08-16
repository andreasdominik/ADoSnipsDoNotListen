
# language settings:
# 1) set LANG to "en", "de", "fr", etc.
# 2) link the Dict with messages to the version with
#    desired language as defined in languages.jl:
#

lang = Snips.getConfig(:language)
const LANG = (lang != nothing) ? lang : "de"

# DO NOT CHANGE THE FOLLOWING 3 LINES UNLESS YOU KNOW
# WHAT YOU ARE DOING!
# set CONTINUE_WO_HOTWORD to true to be able to chain
# commands without need of a hotword in between:
#
const CONTINUE_WO_HOTWORD = true
const DEVELOPER_NAME = "andreasdominik"
Snips.setDeveloperName(DEVELOPER_NAME)
Snips.setModule(@__MODULE__)

# Slots:
# Name of slots to be extracted from intents:
#
# const SLOT_WORD = "a_word"

# name of entry in config.ini:
#
# const INI_MY_NAME = "my_name"

#
# link between actions and intents:
# intent is linked to action{Funktion}
# the action is only matched, if
#   * intentname matches and
#   * if the siteId matches, if site is  defined in config.ini
#     (such as: "switch TV in room abc").
#
# Language-dependent settings:
#
Snips.registerTriggerAction("ADoSnipsListen", triggerListenAction)

if LANG == "de"
    Snips.registerIntentAction("ListenAgainDE", startListenAction)
    Snips.registerIntentAction("DoNotListenDE", stopListenAction)

    const INTENT_LISTEN_AGAIN = "$DEVELOPER_NAME:ListenAgainDE"
    const INTENT_LISTEN_STOP = "$DEVELOPER_NAME:DoNotListenDE"

    const REGEX_STOP = r"^(?:bitte |)hör.?(?: bitte|) (?:weg|nicht mehr zu)$"i
    const REGEX_START = r"^(?:bitte |)hör.?(?: bitte|) (?:wieder zu|zu)$"i
elseif LANG == "en"
    Snips.registerIntentAction("ListenAgainEN", startListenAction)
    Snips.registerIntentAction("DoNotListenEN", stopListenAction)

    const INTENT_LISTEN_AGAIN = "$DEVELOPER_NAME:ListenAgainEN"
    const INTENT_LISTEN_STOP = "$DEVELOPER_NAME:DoNotListenEN"

    const REGEX_STOP = r"^(?:please |)stop listen(?:ing|)$"i
    const REGEX_START = r"^(?:please |)listen again$"i
else
    Snips.registerIntentAction("ListenAgainDE", startListenAction)
    Snips.registerIntentAction("DoNotListenDE", stopListenAction)

    const INTENT_LISTEN_AGAIN = "$DEVELOPER_NAME:ListenAgainDE"
    const INTENT_LISTEN_STOP = "$DEVELOPER_NAME:DoNotListenDE"

    const REGEX_STOP = r"^(?:bitte |)hör.?(?: bitte|) (?:weg|nicht mehr zu)$"i
    const REGEX_START = r"^(?:bitte |)hör.?(?: bitte|) (?:wieder zu|zu)$"i
end
