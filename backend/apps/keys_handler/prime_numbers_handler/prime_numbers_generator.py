# pylint: disable=import-error
import random

from apps.keys_handler.prime_numbers_handler.prime_numbers_checker import (
    is_prime,
)

LENGTH_OF_PRIME_IN_BITS = 30


def generate_large_prime_number():
    """Generate a large prime number."""
    # Length of prime number in bits
    n = LENGTH_OF_PRIME_IN_BITS  # pylint: disable=invalid-name

    # Choose a random integer of a certain length
    num = random.getrandbits(n)

    # Make sure the integer is odd
    num |= 1

    # Test the integer for primality using Miller-Rabin
    while not is_prime(num):
        num += 2

    return num
