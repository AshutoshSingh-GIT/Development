import MAIN

# print(MAIN.custom_function(3,4))
# print(__name__)


class car_tst:
    wheel=4
    currency=80
    def __init__(self,name,price='$ N\A'):
        self.name=name
        self.price=price
        # self.wheel=wheel

    def Amount(self,Amt):
        return self.currency*self.price

obj_1=car_tst('Ashton Martin',100)
print(obj_1)
