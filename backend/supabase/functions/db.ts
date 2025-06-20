import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { RegisteredDevice } from "./types.ts";

const supabaseUrl = Deno.env.get("FUNCTIONS_SUPABASE_URL")!;
const supabaseKey = Deno.env.get("FUNCTIONS_SUPABASE_SERVICE_ROLE_KEY")!;
const supabase = createClient(supabaseUrl, supabaseKey);


export async function fetchRegisteredDevices(
  options: {
    enabledOnly?: boolean;
    deviceType?: "ios" | "android";
  } = {}
) {
  const devices: RegisteredDevice[] = [];
  let lastId = 0;
  let hasMore = true;

  console.log("[Devices] Starting batch fetch of registered devices...");

  while (hasMore) {
    try {
      let query = supabase
        .from("registered_devices_table")
        .select("*")
        .gt("id", lastId)
        .order("id", { ascending: true })
        .limit(BATCH_SIZE);

      // Add filters if specified
      if (options.enabledOnly) {
        query = query.eq("enabled_notifications", true);
      }

      if (options.deviceType) {
        query = query.eq("device_type", options.deviceType);
      }

      const { data, error } = await query;

      if (error) {
        console.error("[Devices] Error fetching batch:", error);
        throw error;
      }

      if (!data || data.length === 0) {
        hasMore = false;
        console.log("[Devices] No more devices to fetch");
        break;
      }

      devices.push(...data);
      lastId = data[data.length - 1].id;
      console.log(
        `[Devices] Fetched batch of ${data.length} devices. Last ID: ${lastId}`
      );

      // If we got fewer results than the batch size, we've reached the end
      if (data.length < BATCH_SIZE) {
        hasMore = false;
      }
    } catch (error) {
      console.error("[Devices] Batch fetch failed:", error);
      throw error;
    }
  }
  console.log(`[Devices] Completed fetch. Total devices: ${devices.length}`);

  return devices;
}

export async function fetchGuardianDeviceTokens(elderId: string) {
  console.log("elderId ", elderId)
  const { data: guardians, error: guardianErr } = await supabase
    .from('guardians')
    .select('guardian_id')
    .eq('elder_id', elderId)
    .eq('confirmed_by_guardian', true)
    
  if (guardianErr || !guardians) {
    console.error('Error fetching guardians:', guardianErr)
    return []
  }

  const guardianIds = guardians.map((g) => g.guardian_id)

  if (guardianIds.length === 0) return []

  // Step 2: Get device tokens for guardian user IDs
  const { data: tokens, error: tokenErr } = await supabase
    .from('device_tokens')
    .select('device_token')
    .in('user_id', guardianIds)

  if (tokenErr || !tokens) {
    console.error('Error fetching device tokens:', tokenErr)
    return []
  }

  return tokens.map((t) => t.device_token)
}

export async function fetchUsersTokens(userIds: string[]) {
  if (userIds.length === 0) return []

  const { data: tokens, error } = await supabase
    .from('device_tokens')
    .select('device_token')
    .in('user_id', userIds)

  if (error || !tokens) {
    console.error('Error fetching device tokens:', error)
    return []
  }

  return tokens.map((t) => t.device_token)
}

export async function fetchUserFullName(userId: string) {
  const { data, error } = await supabase
    .from('profiles')
    .select('full_name')
    .eq('id', userId)
    .single()

  if (error) {
    console.error('Error fetching user full name:', error)
    return null
  }

  return data?.full_name || null
}