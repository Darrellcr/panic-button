// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import "jsr:@supabase/functions-js/edge-runtime.d.ts"
import { sendNotification } from "../notifications.ts"
import { fetchGuardianDeviceTokens } from "../db.ts"

console.log("Hello from Functions!")

Deno.serve(async (req) => {
  const { userId } = await req.json()

  const deviceTokens = await fetchGuardianDeviceTokens(userId)
  console.log("Guardian device tokens:", deviceTokens)
  console.log(await sendNotification({
    title: "🆘 SOS Alert: Your dad activated the SOS button.",
    body: `Track their position now.`,
    category: "sos",
    data: {
      customData: "This is some custom data",
    },
  }, deviceTokens))

  const data = {
    message: "Notification sent successfully",
  }
  return new Response(
    JSON.stringify(data),
    { headers: { "Content-Type": "application/json" } },
  )
})

/* To invoke locally:

  1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
  2. Make an HTTP request:

  curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/send-notification' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
    --header 'Content-Type: application/json' \
    --data '{"name":"Functions"}'

*/
