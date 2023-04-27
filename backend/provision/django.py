from invoke import FailingResponder, Failure, Responder, task

from . import common, start


@task
def manage(context, command, watchers=()):
    """Run manage.py command."""
    return start.run_python(
        context,
        " ".join(["manage.py", command]),
        watchers=watchers,
    )


@task
def makemigrations(context):
    """Run makemigrations command."""
    common.success("Django: Make migrations")
    manage(context, "makemigrations")


@task
def check_new_migrations(context):
    """Check if there is new migrations or not."""
    common.success("Checking migrations")
    manage(context, "makemigrations --check --dry-run")


@task
def migrate(context):
    """Run ``migrate`` command."""
    common.success("Django: Apply migrations")
    manage(context, "migrate")


@task
def createsuperuser(
    context,
    email="root@root.com",
    username="root",
    password="root",
):
    """Create superuser."""
    common.success("Create superuser")
    responder_email = FailingResponder(
        pattern=r"Email address: ",
        response=email + "\n",
        sentinel="That Email address is already taken.",
    )
    responder_user_name = Responder(
        pattern=r"Username: ",
        response=username + "\n",
    )
    responder_password = Responder(
        pattern=r"(Password: )|(Password \(again\): )",
        response=password + "\n",
    )

    try:
        manage(
            context,
            command="createsuperuser",
            watchers=[
                responder_email,
                responder_user_name,
                responder_password,
            ],
        )
    except Failure:
        common.warn("Superuser with that email already exists. Skipped.")


@task
def run(context):
    """Run server."""
    common.success("Django: Run server")
    manage(context, "runserver 8090")
