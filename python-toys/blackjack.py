import random

class Dealer(object):
    def __init__(self):
        self.deck = Dealer.create_deck(4)
        self.hand = []

    def create_deck(n_suits):
        suits = ["Spades", "Hearts", "Clubs", "Diamonds"]
        cards = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']
        res = []
        for i in range(0, n_suits):
            for card in cards:
                res.append((card, suits[i]))
        return res

    def shuffle_deck(self):
        random.shuffle(self.deck)

    def deal_card(self):
        self.hand.append(self.deck.pop(0))


x = Dealer()

print(x.hand)
print(x.deck)
