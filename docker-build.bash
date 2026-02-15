docker run -v ~/.cache/pip:/.cache/pip -v .:/example -it --user $UID --rm --env PYTHON=python3.13 quay.io/pypa/manylinux_2_28_x86_64:latest /bin/bash -c "cd /example && ./build-and-repair.bash"
