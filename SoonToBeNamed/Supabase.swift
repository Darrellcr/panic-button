//
//  Supabase.swift
//  SoonToBeNamed
//
//  Created by Darrell Cornelius Rivaldo on 12/06/25.
//

import Foundation
import Supabase

let supabaseURL = URL(string: "https://cjuysqchugkitvpahosb.supabase.co")!
let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNqdXlzcWNodWdraXR2cGFob3NiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk3NDA5MDcsImV4cCI6MjA2NTMxNjkwN30.OUqMSBXdtOuiN_xcM0RXdmY8WSLoEWJfWV7ErB4ufdY"
let supabase = SupabaseClient(supabaseURL: supabaseURL, supabaseKey: supabaseKey)
