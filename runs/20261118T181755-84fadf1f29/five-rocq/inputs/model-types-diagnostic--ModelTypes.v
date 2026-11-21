From compcert Require Import Csem.
Require PprzTrigPlain.Source PprzTrigInit.Source.
From PprzTrigRelationSupport Require Import EncoderFacts.
From PprzTrigInitSupport Require Import GetNibble NibbleMachine EncoderBody EncoderMemory.
Import PprzTrigPlain.Source.
Set Printing Width 180.
Check @NibbleMachine.get_nibble_literal_expression.
Check @GetNibble.get_nibble_call_total.
Check @EncoderFacts.encoder_low_fact.
Check @EncoderMemory.encoder_setup_exists.
Check @EncoderBody.encoder_call_total.
