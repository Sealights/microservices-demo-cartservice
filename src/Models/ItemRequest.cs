using System.Text.Json.Serialization;

namespace cartservice.Models
{
    public class ItemRequest
    {
        [JsonPropertyName("user_id")]
        public string UserId { get; set; }

        [JsonPropertyName("item")]
        public CartItem Item { get; set; }
    }
}