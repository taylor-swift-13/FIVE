# gh_set_omega generated alignment

Automatic CompCert Csyntax/Cexec export and fresh source audit passed. Generated model remains unrestricted over machine argument lists and CompCert memories. All15 actual CBMC property IDs mapped to pending Rocq obligations; execution coverage and safety/termination/functionality are pending proof. No external calls in entry.

Issues: frozen prepared verification request was a verification scope rather than execution export request; created separate full-domain align/request.json, leaving prepared inputs unchanged. Initial CLI argument preflight attempts rejected before export; corrected exported function name and precise target schema.
