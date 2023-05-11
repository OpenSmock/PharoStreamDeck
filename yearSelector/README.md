# YearSelector
This project shows how a plugin programmed in Pharo for the Elgato Stream Deck can interact with it.
As such, a Stream Deck profile is provided alongside the plugin in order to see its primary functionality in action.

## How it functions
A user can tap one of the Stream Deck keys contained in the aforementioned Stream Deck profile, or place the unique action of the plugin titled "YearSelector" in the action list to change a value. On the Stream Deck, the presses key will change color and appear blue, while the previous highlighted key will revert back to its original color. The change is also made apparent in Pharo, where a notification is sent to inform the user that the value "year" has changed.
It's also possible to directly send a message in Pharo to the concerned class (titled YearSelector), which will impact the highlighted key on the Stream Deck.

Image
