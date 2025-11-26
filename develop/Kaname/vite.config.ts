import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react-swc'

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
  server: {
    host: '0.0.0.0', // すべてのインターフェイスでリッスン
    // 必要に応じてポート番号も設定
    port: 5173,
  },
})
