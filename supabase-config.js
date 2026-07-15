// ============================================================
// PALLAZO STUDIO — Configuração do Supabase
// Cole aqui a URL e a chave "anon public" do seu projeto Supabase.
// Você encontra isso em: Project Settings → API
// ============================================================

const SUPABASE_URL = "https://lhqwxlucoziabzroyrmp.supabase.co";
const SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxocXd4bHVjb3ppYWJ6cm95cm1wIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODQxNDAzMzgsImV4cCI6MjA5OTcxNjMzOH0.xuuw5Ahbeq3s6AUXrvL_3R8zpvObIDYDY-xYjZRhQkM";

const supabaseClient = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

// Nome do bucket de imagens (criado no passo do Storage)
const BUCKET = "uploads";
