using System.Collections.Generic;

namespace cartservice.Models
{
    public interface IMapper
    {
        Cart MapCart(Hipstershop.Cart cart);

        List<CartItem> MapCartItemList(Google.Protobuf.Collections.RepeatedField<Hipstershop.CartItem> grpcCartItems);
    }
}
