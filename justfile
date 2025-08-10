set fallback := true

index:
    #!/usr/bin/env bash

    go run main.go index

clean-provider dir:
    #!/usr/bin/env bash
    dir="{{dir}}"

    rm -rf "./${dir}/.terraform"
    rm -rf "./${dir}/.terraform.lock.hcl"
    rm -rf "./${dir}/provider.json"
    rm -rf "./${dir}/build"

gen-provider dir: (clean-provider dir)
    #!/usr/bin/env bash
    dir="{{dir}}"

    go run main.go gen "./${dir}"

build-provider dir: (gen-provider dir)
    #!/usr/bin/env bash
    dir="{{dir}}"

    jpoet pkg build "./${dir}"

push-provider dir: (build-provider dir)
    #!/usr/bin/env bash
    dir="{{dir}}"

    jpoet pkg push "./${dir}"
