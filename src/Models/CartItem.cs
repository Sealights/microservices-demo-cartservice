using System.Text.Json.Serialization;

namespace cartservice.Models
{
    public class CartItem
    {
        [JsonPropertyName("product_id")]
        public string ProductId { get; set; }

        [JsonPropertyName("quantity")]
        public int Quantity { get; set; }
    }
}