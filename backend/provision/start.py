def run_python(context, command, watchers=()):
    """Run command using python interpreter."""
    return context.run(" ".join(["python3", command]), watchers=watchers)
