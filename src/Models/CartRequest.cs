using System.Text.Json.Serialization;

namespace cartservice.Models
{
    public class CartRequest
    {
        [JsonPropertyName("user_id")]
        public string UserId { get; set; }
    }
}