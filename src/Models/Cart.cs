using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace cartservice.Models
{
    public class Cart
    {
        [JsonPropertyName("user_id")]
        public string UserId { get; set; }

        [JsonPropertyName("items")]
        public List<CartItem> Items { get; set; }
    }
}