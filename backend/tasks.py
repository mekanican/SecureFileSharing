from invoke import Collection
from provision import common, django, linters, start

ns = Collection(common, django, start, linters)

# Configurations for run command
ns.configure(
    {
        "run": {
            "pty": True,
            "echo": True,
        },
    },
)
