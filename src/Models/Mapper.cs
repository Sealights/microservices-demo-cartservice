using System.Collections.Generic;

namespace cartservice.Models
{
    public class Mapper : IMapper
    {
        public Cart MapCart(Hipstershop.Cart cart)
        {
            return new Cart()
            {
                UserId = cart.UserId,
                Items = MapCartItemList(cart.Items)
            };
        }

        public List<CartItem> MapCartItemList(Google.Protobuf.Collections.RepeatedField<Hipstershop.CartItem> grpcCartItems)
        {
            List<CartItem> cartItems = new List<CartItem>();

            for (int i = 0; i < grpcCartItems.Count; i++)
            {
                cartItems.Add(new CartItem() { 
                    ProductId = grpcCartItems[i].ProductId, 
                    Quantity = grpcCartItems[i].Quantity 
                });
            }

            return cartItems;
        }
    }
}
