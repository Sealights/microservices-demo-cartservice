using cartservice.cartstore;
using cartservice.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System.Net.Http;
using System.Threading.Tasks;

namespace cartservice.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class CartController : ControllerBase
    {
        private readonly ILogger<CartController> _logger;
        private readonly ICartStore _cartStore;
        private readonly IMapper _mapper;

        static readonly HttpClient client = new HttpClient();


        public CartController(ILogger<CartController> logger, ICartStore cartStore, IMapper mapper)
        {
            _logger = logger;
            _cartStore = cartStore;
            _mapper = mapper;
        }

        [HttpPost("AddItem")]
        public async Task AddItem(ItemRequest itemRequest)
        {
            if (itemRequest.Item is null)
            {
                _logger.LogInformation("Item is null");

                return;
            }

            await _cartStore.AddItemAsync(itemRequest.UserId, itemRequest.Item.ProductId, itemRequest.Item.Quantity);

            return;
        }

        [HttpPost("GetCart")]
        public async Task<Cart> GetCart(CartRequest cartRequest)
        {
            var grpcCart = await _cartStore.GetCartAsync(cartRequest.UserId);

            string response = await DummyCall();

            return _mapper.MapCart(grpcCart);
        }

        [HttpPost("EmptyCart")]
        public async Task EmptyCart(CartRequest cartRequest)
        {
            await _cartStore.EmptyCartAsync(cartRequest.UserId);

            return;
        }

        private async Task<string> DummyCall()
        {
            try
            {
                HttpResponseMessage response = await client.GetAsync("http://sl-boutique-productcatalog:3552/listproducts");
                response.EnsureSuccessStatusCode();
                string responseBody = await response.Content.ReadAsStringAsync();     

                return responseBody;
            }
            catch (HttpRequestException e)
            {
                return $"Message :{e.Message}";
            }
        }
    }
}