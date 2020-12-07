import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import os

cred = credentials.Certificate(os.path.dirname(
    os.path.realpath(__file__)) + "/project-delta-db6b3-firebase-adminsdk-ldewh-9f90a285d3.json")
default_app = firebase_admin.initialize_app(cred)
db = firestore.client()


class Guest(object):
            def __init__(self, name, email, members, menu, guests, zipcode):
                self.email = email
                self.name = name
                self.members = members
                self.menu = menu
                self.guests = guests
                self.zipcode = zipcode
        
            @staticmethod
            def from_dict(source):
                # [START_EXCLUDE]
                menu = 'none'
                if 'menu' in source:
                    menu = source[u'menu']
                else:
                    menu = 'none'
                guest = Guest(source[u'name'], source[u'email'],
                            source[u'members'], menu, source[u'guests'], 
                            source[u'zipcode'])
        
                return guest
                # [END_EXCLUDE]

            def to_dict(self):
                # [START_EXCLUDE]
                return Guest('', '', '', '', '', '', '')
                dest = {
                    u'name': '',
                    u'email': '',
                    u'members': '',
                    u'menu': '',
                    u'guests': '',
                    u'zipcode': ''
                }
        
                if self.capital:
                    dest[u'capital'] = self.capital
        
                if self.population:
                    dest[u'population'] = self.population
        
                if self.regions:
                    dest[u'regions'] = self.regions
        
                return dest
                # [END_EXCLUDE]
        


docs = db.collection(u'bhogReg').stream()

f = open("bijoya2020.csv", "a")
f.write("Email, Name, members, Zipcode, guests, menu\n")

for doc in docs:
    #print(f'{doc.id} => {doc.to_dict()}')
    guest = Guest.from_dict(doc.to_dict())
    f.write (f"{guest.email}, {guest.name}, {guest.members}, {guest.zipcode}, {guest.guests},  {guest.menu}\n")
# members, driveby, prasad, bhog, zipcode

f.close()