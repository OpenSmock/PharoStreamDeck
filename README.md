[![License](https://img.shields.io/github/license/openSmock/PharoStreamDeck.svg)](./LICENSE)
[![Pharo 12 CI](https://github.com/OpenSmock/PharoStreamDeck/actions/workflows/Pharo12CI.yml/badge.svg)](https://github.com/OpenSmock/PharoStreamDeck/actions/workflows/Pharo12CI.yml)

# PharoStreamDeck
Elgato Stream Deck utils for Pharo \
![stream_deck-removebg-preview](https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/12eb50ac-f229-4001-80a5-31186f999604)

## General
This project shows how Stream Deck buttons can interact with the Pharo IDE by using Pharo's code.

## Contents of this GitHub repository
The src folder, which contains the PharoStreamDeck plugin, shows how a plugin made in Pharo can interact with the Elgato's Stream Deck.

## To install in Pharo
```smalltalk
Metacello new
   baseline: 'PharoStreamDeck';
   repository: 'github://OpenSmock/PharoStreamDeck:main/src';
   load.
```
