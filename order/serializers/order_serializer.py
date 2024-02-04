from rest_framework import serializers

from product.models import Product
from product.serializers.product_serializer import product_serializer

class OrderSerializer(serializers.ModelSerializer):
    product = ProductSerializer(required=True, many=True)
    products_id = serializers.PrimaryKeyRelatedField(queryset=Product.objects.all(), write_only=True, many=True)
    total = serializers.SerializerMethodField()


    def get_total(self, instance):
        total = sum([product.price for product in instance.product.all()])
        return total
    
    class Meta:
        model = Order
        fields = ['product', 'total', 'user', 'products_id']
        extra_kwargs = {'product': {'required': False}}
    
    def create(self, validated_data):
        product_data = validated_data.pop('products_id')
        user_data = validated_data.pop('user')

        order = Order.objects.create(user_data)
        for product in product_data:
            order.product.add(product)

        return order