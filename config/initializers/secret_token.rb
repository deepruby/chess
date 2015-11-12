# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Chess::Application.config.secret_key_base = 'c43df14e45faec77e183de25245e7903009f4b2c375148e9592ee801cf339acf48b1ce9fc891552265f8240c021df7fcd671fb7a53424212602e822d75e0d1bc'
