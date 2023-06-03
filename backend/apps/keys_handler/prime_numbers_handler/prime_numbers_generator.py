# pylint: disable=import-error,invalid-name,no-name-in-module
# import random # random is weak, do not use for secure system!
import secrets

from apps.keys_handler.prime_numbers_handler.prime_numbers_checker import (
    is_prime,
)
from gmpy2 import mpz  # speedup calculating

LENGTH_OF_PRIME_IN_BITS = 512


def generate_large_prime_number():
    """Generate a large prime number."""
    # Length of prime number in bits
    n = LENGTH_OF_PRIME_IN_BITS  # pylint: disable=invalid-name

    # https://en.wikipedia.org/wiki/Safe_and_Sophie_Germain_primes
    # generate prime Z = 2p + 1, p is prime too
    p = 1
    while True:
        p = random_bit(n - 1) | 1  # 2*p -> n bit
        if is_prime(p) and is_prime(2 * p + 1):
            break

    return 2 * int(p) + 1


def random_bit(N: int) -> mpz:
    """Generate N random bit."""
    # Random in range [2^{n - 1}, 2^{n} - 1]
    temp_pow = pow(mpz(2), N - 1)  # optimize

    # Choose random in [0, 2^{n - 1})
    rand = mpz(secrets.randbelow(temp_pow))

    # Set most significant bit
    rand |= temp_pow

    return rand
