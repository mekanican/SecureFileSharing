# pylint: disable=invalid-name
import random


def is_prime(n, k=10):
    """Miller-Rabin primality test."""
    # Handle the base cases
    if n in (2, 3):
        return True
    if n < 2 or n % 2 == 0:
        return False

    # Write n - 1 as 2^r * d
    d = n - 1
    r = 0
    while d % 2 == 0:
        d //= 2
        r += 1

    # Test k times
    for _ in range(k):
        a = random.randint(2, n - 2)
        x = pow(a, d, n)
        if x in (1, n - 1):
            continue
        for _ in range(r - 1):
            x = pow(x, 2, n)
            if x == n - 1:
                break
        else:
            return False
    return True
