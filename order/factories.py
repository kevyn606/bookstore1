import factory
from django.contrib.auth.models import User
from product.factories import ProductFactory

from order.models import Order

class UserFactory(factory.django.DjangoModelFactory):
    email = factory.Faker('pystr')
    username = factory.Faker('pystr')

    class Meta:
        model = User

class OrderFactory(dactory.django.DjangoModelFactory):
    user = factory.SubFactory(UserFactory)

    @factory.post_generation
    def category(self, create, extractef, **kwargs):
        if not create:
            return
        
        if extracted:
            for category in extracted:
                self.product.add(product)
    
    class Meta:
        model = Order