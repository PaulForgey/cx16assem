import string
import random

def process_word(w):
    w = w.rstrip()
    w2 = [char for char in w if char in string.ascii_letters]
    return "".join(w2).upper()

raw_words = random.sample(open("/usr/share/dict/words", "rt").readlines(), 100)
words = [pw for pw in [process_word(w) for w in raw_words] if pw]


def create_labelname(idx):
    w1 = random.choice(words)
    w2 = random.choice(words)
    name = (w1+w2)[:25].upper()
    return name + "." + str(idx) + random.choice(string.ascii_uppercase+string.digits)


maximum = int(input("max number of labels? "))
labels = [create_labelname(idx) for idx in range(maximum)]


def test_strategy(labels):
    for label in labels:
        length=len(label)
        c0 = ord(label[0])
        c1 = ord(label[1])
        clast = ord(label[length-1])
        idx = (c0 + clast + length) ^ (c1*4)
        idx &= 127
        print(idx, label)


def write_data(labels):
    with open("labels.bin", "wb") as out:
        for label in labels:
            print(label)
            out.write(label.encode("ascii"))
            out.write(b'\0')


test_strategy(labels)
write_data(labels)
