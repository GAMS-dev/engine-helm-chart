import binascii
import hashlib
import os
import sys
from string import Template


def pad_to_eight(input_str):
    return '0' * (8 - len(input_str)) + input_str


def encode_rabbit_password_hash(salt, password):
    salt_and_password = salt + password.encode('utf-8').hex()
    salt_and_password = bytearray.fromhex(salt_and_password)
    salted_sha256 = hashlib.sha256(salt_and_password).hexdigest()
    password_hash = bytearray.fromhex(salt + salted_sha256)
    password_hash = binascii.b2a_base64(password_hash).strip().decode('utf-8')
    return password_hash


def decode_rabbit_password_hash(password_hash):
    password_hash = binascii.a2b_base64(password_hash)
    decoded_hash = bytes.hex(password_hash)
    return decoded_hash[0:8], decoded_hash[8:]


def check_rabbit_password(test_password, password_hash):
    salt, hash_md5sum = decode_rabbit_password_hash(password_hash)
    test_password_hash = encode_rabbit_password_hash(salt, test_password)
    return test_password_hash == password_hash


def encode_rabbit_pasword(password):
    random_int = int.from_bytes(os.urandom(4), byteorder='little')
    password_hash = encode_rabbit_password_hash(pad_to_eight(hex(random_int)[2:]), password)
    return password_hash


def generate_password_hash(password):
    random_int = int.from_bytes(os.urandom(4), byteorder='little')
    password_hash = encode_rabbit_password_hash(pad_to_eight(hex(random_int)[2:]), password)
    return password_hash

if __name__ == '__main__':
    hashes = {}

    for key in os.environ:
        if not key.startswith("GMS_RUNNER_RABBIT"):
            continue

        password = os.environ[key]
        password_hash = generate_password_hash(password)
        if check_rabbit_password(password, password_hash):
            hashes[key] = password_hash
        else:
            print('Error while generating hash for', key)
            sys.exit(1)
    
    with open("/data_in/definitions.json", "r") as f:
        template_content = f.read()

    result = Template(template_content).safe_substitute(hashes)

    with open("/data_out/definitions.json", "w") as f:
        f.write(result)