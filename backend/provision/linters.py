from invoke import Exit, UnexpectedExit, task

from . import common, start

##############################################################################
# Linters
##############################################################################

DEFAULT_FOLDERS = "apps provision tasks.py"


@task
def pylint(context, path=DEFAULT_FOLDERS):
    """Run `pylint` linter."""
    common.success("Linters: PyLint running")
    start.run_python(context, "-m pylint " + path)


# pylint: disable=redefined-builtin
@task
def all(context, path=DEFAULT_FOLDERS):
    """Run all linters."""
    common.success("Linters: running all linters")
    linters = (pylint,)
    failed = []
    for linter in linters:
        try:
            linter(context, path)
        except UnexpectedExit:
            failed.append(linter.__name__)
    if failed:
        common.error(
            f"Linters failed: {', '.join(map(str.capitalize, failed))}",
        )
        raise Exit(code=1)
