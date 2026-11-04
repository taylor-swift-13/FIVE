# State and horizontal guidance reference

The 138 state interfaces are split into four source groups. Each group retains the original state implementation in its shared CompCert source and exports the indicated header interfaces as entry cases. `state_2` groups position, speed and acceleration interfaces; `state_3` groups attitude, rates and wind interfaces. The groups have separate global environments, so cross-group composition requires an explicit correspondence relation.

Candidate functional properties include bit-preserving set/get operations under suitable memory conditions, valid-status preservation, and correct transitions between cached coordinate representations. High-level multi-cycle properties can be proved by induction after the local contracts and external conversion interfaces are established.

The horizontal guidance reference depends on a genuine generated aircraft header. The attempted build and missing generator dependencies are in [limitations](limitations.md). No proof has been attempted in this batch.
