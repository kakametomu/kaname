# プロダクト要件定義書

## プロダクト概要

**名称:** Kaname-Project 
**概要:** ブラウザで使えるE2E暗号化対応のプライバシー重視メモアプリ  
**ターゲット:** 個人の日記・学習帳として、プライバシーを重視するユーザー

---

## 技術スタック

### フロントエンド
- React + TypeScript
- マークダウンエディタ: CodeMirror または Monaco Editor
- シンタックスハイライト: highlight.js または Prism.js
- オフライン対応: Service Worker + IndexedDB

### バックエンド
- Supabase (認証 + データベース + ストレージ)

### セキュリティ
- 暗号化: AES-256-GCM
- 鍵導出: Argon2id または PBKDF2
- 認証: ランダムID/パスワード + パスキー

---

## コア機能仕様

### 1. 認証・セキュリティ

#### 初回登録
- ランダムなユーザーID自動生成
- ランダムなパスワード自動生成
- リカバリーキー発行(24単語のニーモニック形式)
- パスキー登録を促す(オプション)

#### ログイン
- ID/パスワード認証
- パスキー認証(Phase 2以降)
- セッション管理: デフォルト1時間で自動ログアウト(Phase 3で設定可能に)

#### E2E暗号化対象
- メモ本文
- メモタイトル
- フォルダ名
- タグ
- 画像

#### 暗号化キー管理
- マスターキーをパスワードから導出
- パスキー使用時はマスターキーを暗号化してサーバー保存

---

### 2. データ構造

#### メモ
- タイトル
- 本文(マークダウン)
- タグ(複数可、別途入力欄)
- 作成日時
- 更新日時
- 所属フォルダ

#### フォルダ
- フォルダ名
- 階層構造(無制限)
- 親フォルダID

#### 画像
- 上限: 10MB/画像
- 自動最適化: デフォルトON(長辺1920px、品質85%)
- 設定でオリジナル保持可能(Phase 3)
- 暗号化してSupabase Storageに保存

---

### 3. UI/UX

#### レイアウト
```
[サイドバー] | [メインエディタエリア]
```

#### サイドバー
- フォルダツリー表示
- 階層構造の展開/折りたたみ
- ドラッグ&ドロップでメモ/フォルダ移動(Phase 2)
- 検索バー

#### メインエディタ
- 編集モード/プレビューモード切り替え(デフォルト)
- リアルタイムプレビュー設定(Phase 3)
- 自動保存(入力停止後2-3秒)
- タグ入力欄
- コードブロックのシンタックスハイライト(Phase 2)

#### 検索機能
- ファイル名検索(Phase 1)
- 全文検索(Phase 2)
- タブまたはトグルで切り替え
- ショートカットキー対応(Phase 2)
- 検索結果ハイライト(Phase 2)

---

### 4. オフライン対応 (Phase 4)

#### 実装
- Service Worker + IndexedDB
- 暗号化データをローカルキャッシュ
- オフラインで閲覧・編集・新規作成可能
- 画像アップロードはオンライン時のみ

#### コンフリクト解決
- 方式: ユーザー選択式
- 衝突検出時にダイアログ表示
- どちらのバージョンを採用するか選択
- または両方を保持するオプション

---

### 5. エクスポート/インポート (Phase 3)

#### エクスポート
- 単一メモ: Markdownファイル(.md)
- 複数メモ/フォルダ: ZIPアーカイブ
- 画像も含めて出力
- フォルダ構造を保持

#### インポート
- Markdownファイル
- ZIPアーカイブ(フォルダ構造ごと)
- 画像の自動再暗号化

---

## 段階的リリース計画

### Phase 1: MVP (最小限で動くバージョン)
- [ ] ランダムID/パスワード生成認証
- [ ] リカバリーキー発行
- [ ] 基本的なメモ作成・編集(マークダウン)
- [ ] フォルダ管理(階層構造、手動操作)
- [ ] E2E暗号化
- [ ] 編集/プレビューモード切り替え
- [ ] 自動保存
- [ ] ファイル名検索
- [ ] 自動ログアウト(1時間固定)

### Phase 2: 使いやすさ向上
- [ ] パスキー対応
- [ ] ドラッグ&ドロップでフォルダ移動
- [ ] 全文検索
- [ ] 検索結果ハイライト
- [ ] タグ機能
- [ ] コードブロックのシンタックスハイライト
- [ ] ショートカットキー

### Phase 3: 高度な機能
- [ ] 画像アップロード(暗号化)
- [ ] 画像最適化(自動/設定)
- [ ] エクスポート/インポート機能
- [ ] リアルタイムプレビュー設定
- [ ] セッションタイムアウト時間の設定
- [ ] 画像最適化ON/OFF設定

### Phase 4: オフライン・PWA化
- [ ] オフライン対応
- [ ] Service Worker実装
- [ ] 同期・コンフリクト解決(ユーザー選択式)
- [ ] PWAとしてインストール可能に

---

## 非機能要件

### パフォーマンス
- 初回ロード: 3秒以内
- メモ切り替え: 500ms以内
- 自動保存の遅延: 入力停止後2-3秒

### セキュリティ
- サーバーは暗号化データのみ保持(平文なし)
- クライアント側でのみ復号化
- XSS/CSRF対策

### ブラウザ対応
- Chrome, Firefox, Safari, Edge (最新版)
- モバイルブラウザ対応

---

---

## プロダクト名

**Kaname (要)**

「要」= 大切なもの、かなめ  
プライバシーを守る重要なメモアプリというコンセプトを表現

---

## デザイン方向性

### カラースキーム
- **ライト&ダークモード両対応**
  - ライト: 白ベース、アクセントに深緑や藍色
  - ダーク: 黒ベース、アクセントに柔らかい青
  - ユーザーが選択可能

### UI全体の雰囲気
- **ミニマル・クリーン**
  - 余計な装飾なし
  - 機能重視
  - シンプルで使いやすい

---

## データベーススキーマ設計

### テーブル構成

#### 1. users テーブル
```sql
users
- id: uuid (primary key)
- user_id: text (ランダム生成されたユーザーID, unique)
- encrypted_master_key: text (パスキー用の暗号化されたマスターキー)
- password_hash: text (認証用、Supabase Auth使用)
- recovery_key_hash: text (リカバリーキーのハッシュ)
- subscription_tier: text (デフォルト: 'free') -- 'free' | 'premium' | 'trial'
- subscription_status: text (デフォルト: 'active') -- 'active' | 'expired' | 'cancelled'
- subscription_started_at: timestamp (nullable)
- subscription_expires_at: timestamp (nullable) -- trialとpremiumの期限管理
- trial_used: boolean (デフォルト: false) -- トライアル使用済みフラグ
- storage_used_bytes: bigint (デフォルト: 0)
- stripe_customer_id: text (nullable) -- Stripe連携用
- stripe_subscription_id: text (nullable) -- Stripe連携用
- created_at: timestamp
- updated_at: timestamp
```

#### 2. folders テーブル
```sql
folders
- id: uuid (primary key)
- user_id: uuid (foreign key to users.id)
- encrypted_name: text (暗号化されたフォルダ名)
- parent_folder_id: uuid (nullable, self-reference)
- order_index: integer (表示順)
- created_at: timestamp
- updated_at: timestamp
```

#### 3. notes テーブル
```sql
notes
- id: uuid (primary key)
- user_id: uuid (foreign key to users.id)
- folder_id: uuid (nullable, foreign key to folders.id)
- encrypted_title: text (暗号化されたタイトル)
- encrypted_content: text (暗号化された本文)
- encrypted_tags: text (暗号化されたタグのJSON配列)
- order_index: integer (フォルダ内での表示順)
- created_at: timestamp
- updated_at: timestamp
- last_synced_at: timestamp (オフライン同期用、Phase 4)
```

#### 4. images テーブル
```sql
images
- id: uuid (primary key)
- user_id: uuid (foreign key to users.id)
- note_id: uuid (foreign key to notes.id)
- encrypted_filename: text (暗号化されたファイル名)
- storage_path: text (Supabase Storage上のパス)
- encrypted_metadata: text (暗号化されたメタデータJSON: サイズ、MIME type等)
- created_at: timestamp
```

#### 5. settings テーブル (Phase 3)
```sql
settings
- id: uuid (primary key)
- user_id: uuid (foreign key to users.id, unique)
- encrypted_settings: text (暗号化された設定JSON)
- updated_at: timestamp
```

### インデックス設計

```sql
-- パフォーマンス最適化用
CREATE INDEX idx_folders_user_id ON folders(user_id);
CREATE INDEX idx_folders_parent_id ON folders(parent_folder_id);
CREATE INDEX idx_notes_user_id ON notes(user_id);
CREATE INDEX idx_notes_folder_id ON notes(folder_id);
CREATE INDEX idx_notes_updated_at ON notes(updated_at DESC);
CREATE INDEX idx_images_note_id ON images(note_id);
```

### Row Level Security (RLS) ポリシー

```sql
-- ユーザーは自分のデータのみアクセス可能
ALTER TABLE folders ENABLE ROW LEVEL SECURITY;
ALTER TABLE notes ENABLE ROW LEVEL SECURITY;
ALTER TABLE images ENABLE ROW LEVEL SECURITY;
ALTER TABLE settings ENABLE ROW LEVEL SECURITY;

-- folders
CREATE POLICY "Users can view their own folders"
  ON folders FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own folders"
  ON folders FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own folders"
  ON folders FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own folders"
  ON folders FOR DELETE
  USING (auth.uid() = user_id);

-- notes, images, settings も同様のポリシーを適用
```

### Supabase Storage バケット設定

```
bucket: kaname-images
- private (認証必須)
- RLS有効
- ユーザーごとのフォルダ: {user_id}/{image_id}
- 最大ファイルサイズ: 10MB
```

---

## 課金設計

### 決済プラットフォーム
- **Stripe** を採用

### プラン構成

#### Freeプラン
- ストレージ: 100MB
- 画像サイズ: 5MB/枚
- 機能制限:
  - オフラインモード: ✗
  - エクスポート/インポート: ✓
  - 全文検索: ✗ (ファイル名検索のみ)
  - カスタムセッションタイムアウト: ✗
  - 画像最適化設定: ✗
  - リアルタイムプレビュー: ✗

#### Trialプラン (1ヶ月)
- Premiumと同じ機能・制限
- 1ユーザーあたり1回のみ利用可能

#### Premiumプラン
- ストレージ: 10GB
- 画像サイズ: 10MB/枚
- 全機能利用可能:
  - オフラインモード: ✓
  - エクスポート/インポート: ✓
  - 全文検索: ✓
  - カスタムセッションタイムアウト: ✓
  - 画像最適化設定: ✓
  - リアルタイムプレビュー: ✓

### トライアルフロー

```
1. 新規登録 → Free プラン
2. トライアル開始 → Trial プラン (30日間)
3. トライアル期限切れ → Free プランに自動ダウングレード
4. Premium購入 → Premium プラン (Stripe経由)
```

### Phase別実装計画

**Phase 1 (MVP):**
- テーブルにフィールドは用意
- 全ユーザーFreeプランで全機能利用可能(制限なし)

**Phase 3 (高度な機能):**
- ストレージ使用量の計測・表示
- プラン制限の実装
- 制限超過時の警告UI

**Phase 4または5 (収益化):**
- Stripe連携
- トライアル機能
- Premium購読機能
- 決済UI

---

---

## Phase 1: 詳細な技術設計

### 1. フロントエンドのディレクトリ構成

```
kaname/
├── src/
│   ├── components/           # UIコンポーネント
│   │   ├── auth/            # 認証関連
│   │   │   ├── LoginForm.tsx
│   │   │   ├── SignupForm.tsx
│   │   │   └── RecoveryKeyDisplay.tsx
│   │   ├── editor/          # エディタ関連
│   │   │   ├── MarkdownEditor.tsx
│   │   │   ├── MarkdownPreview.tsx
│   │   │   └── EditorToolbar.tsx
│   │   ├── sidebar/         # サイドバー関連
│   │   │   ├── Sidebar.tsx
│   │   │   ├── FolderTree.tsx
│   │   │   ├── FolderItem.tsx
│   │   │   ├── NoteItem.tsx
│   │   │   └── SearchBar.tsx
│   │   ├── layout/          # レイアウト
│   │   │   ├── Layout.tsx
│   │   │   └── Header.tsx
│   │   └── common/          # 共通コンポーネント
│   │       ├── Button.tsx
│   │       ├── Input.tsx
│   │       ├── Modal.tsx
│   │       └── Loading.tsx
│   ├── lib/                 # ライブラリ・ユーティリティ
│   │   ├── crypto/          # 暗号化関連
│   │   │   ├── encryption.ts
│   │   │   ├── keyDerivation.ts
│   │   │   └── recoveryKey.ts
│   │   ├── supabase/        # Supabase関連
│   │   │   ├── client.ts
│   │   │   ├── auth.ts
│   │   │   ├── notes.ts
│   │   │   └── folders.ts
│   │   └── utils/           # ユーティリティ
│   │       ├── validation.ts
│   │       └── formatters.ts
│   ├── hooks/               # カスタムフック
│   │   ├── useAuth.ts
│   │   ├── useNotes.ts
│   │   ├── useFolders.ts
│   │   └── useAutoSave.ts
│   ├── store/               # 状態管理
│   │   ├── authStore.ts
│   │   ├── notesStore.ts
│   │   └── uiStore.ts
│   ├── types/               # 型定義
│   │   ├── auth.ts
│   │   ├── note.ts
│   │   ├── folder.ts
│   │   └── database.ts
│   ├── pages/               # ページ
│   │   ├── Login.tsx
│   │   ├── Signup.tsx
│   │   ├── Dashboard.tsx
│   │   └── NotFound.tsx
│   ├── App.tsx
│   └── main.tsx
├── public/
├── package.json
├── tsconfig.json
├── vite.config.ts
└── tailwind.config.js
```

### 2. 技術スタック

**フロントエンド:**
- React 18+ with TypeScript
- Vite (ビルドツール)
- Tailwind CSS (スタイリング)
- Zustand (状態管理)
- React Router (ルーティング)
- CodeMirror または Monaco Editor (マークダウンエディタ)

**暗号化:**
- Web Crypto API (AES-256-GCM)
- PBKDF2 (鍵導出、600,000回イテレーション)

**バックエンド:**
- Supabase (認証・DB・Storage)

**開発ツール:**
- ESLint + Prettier
- Vitest (テスト、Phase 2以降)

### 3. 暗号化実装

```typescript
// AES-GCM で暗号化
export async function encrypt(
  plaintext: string, 
  password: string
): Promise<{ ciphertext: string; iv: string; salt: string }> {
  // 1. パスワードから鍵を導出
  const salt = crypto.getRandomValues(new Uint8Array(16));
  const key = await deriveKey(password, salt);
  
  // 2. 初期化ベクトル生成
  const iv = crypto.getRandomValues(new Uint8Array(12));
  
  // 3. 暗号化
  const encoder = new TextEncoder();
  const data = encoder.encode(plaintext);
  
  const ciphertext = await crypto.subtle.encrypt(
    { name: 'AES-GCM', iv },
    key,
    data
  );
  
  // 4. Base64エンコードして返す
  return {
    ciphertext: arrayBufferToBase64(ciphertext),
    iv: arrayBufferToBase64(iv),
    salt: arrayBufferToBase64(salt)
  };
}

// 復号化
export async function decrypt(
  ciphertext: string,
  iv: string,
  salt: string,
  password: string
): Promise<string> {
  const key = await deriveKey(password, base64ToArrayBuffer(salt));
  
  const decrypted = await crypto.subtle.decrypt(
    { name: 'AES-GCM', iv: base64ToArrayBuffer(iv) },
    key,
    base64ToArrayBuffer(ciphertext)
  );
  
  const decoder = new TextDecoder();
  return decoder.decode(decrypted);
}

// 鍵導出 (PBKDF2)
async function deriveKey(password: string, salt: Uint8Array): Promise<CryptoKey> {
  const encoder = new TextEncoder();
  const passwordBuffer = encoder.encode(password);
  
  const importedKey = await crypto.subtle.importKey(
    'raw',
    passwordBuffer,
    'PBKDF2',
    false,
    ['deriveKey']
  );
  
  return crypto.subtle.deriveKey(
    {
      name: 'PBKDF2',
      salt: salt,
      iterations: 600000,
      hash: 'SHA-256'
    },
    importedKey,
    { name: 'AES-GCM', length: 256 },
    false,
    ['encrypt', 'decrypt']
  );
}
```

### 4. 認証フロー

#### 新規登録フロー

```
1. ユーザーが「新規登録」ボタンをクリック
   ↓
2. ランダムなユーザーIDとパスワードを生成
   user_id: "kaname_" + nanoid(16)  // 例: kaname_a1b2c3d4e5f6g7h8
   password: nanoid(32)              // 例: x9y8z7w6v5u4t3s2r1q0p9o8n7m6l5k4
   ↓
3. パスワードから暗号化マスターキーを導出
   masterKey = PBKDF2(password, salt, 600000回)
   ↓
4. リカバリーキーを生成(BIP39形式の24単語)
   recoveryKey = generateMnemonic(24)
   ↓
5. Supabase Authにユーザー登録
   email: {user_id}@kaname.local (ダミーメール)
   password: password
   ↓
6. usersテーブルに追加情報を保存
   - user_id
   - recovery_key_hash
   - subscription_tier: 'free'
   ↓
7. 画面に表示してユーザーに保存を促す:
   「以下の情報を安全な場所に保存してください」
   - ユーザーID: kaname_xxxxx
   - パスワード: xxxxx
   - リカバリーキー: word1 word2 word3 ... (24単語)
   ↓
8. 「保存しました」チェックボックスにチェック後、ダッシュボードへ
```

#### ログインフロー

```
1. ユーザーID & パスワード入力
   ↓
2. Supabase Authで認証
   email: {user_id}@kaname.local
   password: password
   ↓
3. 認証成功
   ↓
4. パスワードからマスターキーを導出
   masterKey = PBKDF2(password, salt, 600000回)
   ↓
5. マスターキーをメモリ(Zustandストア)に保持
   ↓
6. セッションタイマー開始(1時間)
   ↓
7. ダッシュボードへ
```

#### リカバリーフロー

```
1. 「パスワードを忘れた」をクリック
   ↓
2. ユーザーIDとリカバリーキー(24単語)を入力
   ↓
3. リカバリーキーのハッシュを検証
   ↓
4. 検証成功 → 新しいパスワードを生成
   ↓
5. Supabase Authのパスワードを更新
   ↓
6. 新しいパスワードを表示
   「新しいパスワード: xxxxx」
   「必ず保存してください」
   ↓
7. ログイン画面へ
```

### 5. セッション管理

```typescript
// セッションタイマーの実装
class SessionManager {
  private timer: NodeJS.Timeout | null = null;
  private timeout = 60 * 60 * 1000; // 1時間 (ミリ秒)
  
  start() {
    this.reset();
  }
  
  reset() {
    if (this.timer) clearTimeout(this.timer);
    
    this.timer = setTimeout(() => {
      this.logout();
    }, this.timeout);
  }
  
  logout() {
    // 1. Zustandストアからマスターキーを削除
    useAuthStore.getState().clearMasterKey();
    
    // 2. Supabaseセッションを終了
    supabase.auth.signOut();
    
    // 3. ログイン画面へリダイレクト
    window.location.href = '/login';
  }
}

// キー入力やマウス操作でタイマーをリセット
document.addEventListener('keydown', () => sessionManager.reset());
document.addEventListener('mousemove', throttle(() => sessionManager.reset(), 1000));
```

### 6. データフロー

#### メモ作成時

```
1. ユーザーがメモを作成
   ↓
2. クライアント側でタイトルと本文を暗号化
   encryptedTitle = encrypt(title, masterKey)
   encryptedContent = encrypt(content, masterKey)
   ↓
3. Supabaseに保存
   INSERT INTO notes (user_id, folder_id, encrypted_title, encrypted_content)
   ↓
4. ローカルの状態を更新(Zustand)
   notesStore.addNote(newNote)
```

#### メモ読み込み時

```
1. Supabaseから暗号化データを取得
   SELECT * FROM notes WHERE user_id = current_user_id
   ↓
2. クライアント側で復号化
   title = decrypt(encryptedTitle, masterKey)
   content = decrypt(encryptedContent, masterKey)
   ↓
3. UIに表示
```

#### 自動保存

```typescript
// useAutoSave フックの実装
export function useAutoSave(noteId: string, content: string) {
  const debouncedSave = useMemo(
    () => debounce(async (content: string) => {
      // 1. 暗号化
      const encrypted = await encrypt(content, masterKey);
      
      // 2. Supabaseに保存
      await supabase
        .from('notes')
        .update({ 
          encrypted_content: encrypted.ciphertext,
          iv: encrypted.iv,
          salt: encrypted.salt,
          updated_at: new Date().toISOString()
        })
        .eq('id', noteId);
      
      // 3. 保存完了をUI表示
      toast.success('自動保存しました');
    }, 2000), // 2秒のデバウンス
    [noteId, masterKey]
  );
  
  useEffect(() => {
    if (content) {
      debouncedSave(content);
    }
  }, [content, debouncedSave]);
}
```

### 7. エラーハンドリング

```typescript
// エラー種類の定義
export class AuthenticationError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'AuthenticationError';
  }
}

export class EncryptionError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'EncryptionError';
  }
}

export class NetworkError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'NetworkError';
  }
}

// エラーハンドリング戦略
try {
  const encrypted = await encrypt(data, key);
} catch (error) {
  if (error instanceof EncryptionError) {
    // 暗号化エラー → セッション切れの可能性
    toast.error('セッションが切れました。再ログインしてください');
    logout();
  } else if (error instanceof NetworkError) {
    // ネットワークエラー → リトライ
    toast.error('ネットワークエラーが発生しました');
  } else {
    // 予期しないエラー
    console.error('Unexpected error:', error);
    toast.error('エラーが発生しました');
  }
}
```

---

### 8. TypeScript 型定義

#### auth.ts - 認証関連の型

```typescript
// src/types/auth.ts

/**
 * ユーザー認証情報
 */
export interface User {
  id: string;
  userId: string; // kaname_xxxxx形式
  subscriptionTier: SubscriptionTier;
  subscriptionStatus: SubscriptionStatus;
  subscriptionStartedAt: Date | null;
  subscriptionExpiresAt: Date | null;
  trialUsed: boolean;
  storageUsedBytes: number;
  createdAt: Date;
  updatedAt: Date;
}

/**
 * サブスクリプションプラン
 */
export type SubscriptionTier = 'free' | 'premium' | 'trial';

/**
 * サブスクリプション状態
 */
export type SubscriptionStatus = 'active' | 'expired' | 'cancelled';

/**
 * 新規登録時の認証情報
 */
export interface SignupCredentials {
  userId: string;
  password: string;
  recoveryKey: string; // 24単語のニーモニック
}

/**
 * ログイン情報
 */
export interface LoginCredentials {
  userId: string;
  password: string;
}

/**
 * リカバリー情報
 */
export interface RecoveryCredentials {
  userId: string;
  recoveryKey: string;
}

/**
 * 認証状態
 */
export interface AuthState {
  user: User | null;
  masterKey: CryptoKey | null; // メモリ上に保持される暗号化キー
  isAuthenticated: boolean;
  isLoading: boolean;
  sessionExpiresAt: Date | null;
}

/**
 * セッション情報
 */
export interface Session {
  userId: string;
  expiresAt: Date;
  lastActivityAt: Date;
}
```

#### note.ts - メモ関連の型

```typescript
// src/types/note.ts

/**
 * メモ(復号化済み)
 */
export interface Note {
  id: string;
  userId: string;
  folderId: string | null;
  title: string; // 復号化済み
  content: string; // 復号化済み
  tags: string[]; // 復号化済み
  orderIndex: number;
  createdAt: Date;
  updatedAt: Date;
  lastSyncedAt: Date | null; // Phase 4で使用
}

/**
 * メモ(暗号化済み) - DB保存用
 */
export interface EncryptedNote {
  id: string;
  userId: string;
  folderId: string | null;
  encryptedTitle: string;
  encryptedContent: string;
  encryptedTags: string;
  titleIv: string;
  titleSalt: string;
  contentIv: string;
  contentSalt: string;
  tagsIv: string;
  tagsSalt: string;
  orderIndex: number;
  createdAt: Date;
  updatedAt: Date;
  lastSyncedAt: Date | null;
}

/**
 * メモ作成用の入力データ
 */
export interface CreateNoteInput {
  folderId: string | null;
  title: string;
  content: string;
  tags: string[];
}

/**
 * メモ更新用の入力データ
 */
export interface UpdateNoteInput {
  id: string;
  title?: string;
  content?: string;
  tags?: string[];
  folderId?: string | null;
  orderIndex?: number;
}

/**
 * メモ検索結果
 */
export interface NoteSearchResult {
  note: Note;
  matchedText: string; // マッチした部分のテキスト
  highlights: SearchHighlight[];
}

/**
 * 検索ハイライト情報
 */
export interface SearchHighlight {
  start: number;
  end: number;
  text: string;
}

/**
 * 検索クエリ
 */
export interface SearchQuery {
  query: string;
  type: SearchType;
  folderId?: string | null; // 特定フォルダ内のみ検索
}

/**
 * 検索タイプ
 */
export type SearchType = 'filename' | 'fulltext';
```

#### folder.ts - フォルダ関連の型

```typescript
// src/types/folder.ts

/**
 * フォルダ(復号化済み)
 */
export interface Folder {
  id: string;
  userId: string;
  name: string; // 復号化済み
  parentFolderId: string | null;
  orderIndex: number;
  createdAt: Date;
  updatedAt: Date;
  children?: Folder[]; // ツリー構造用
  isExpanded?: boolean; // UI状態管理用
}

/**
 * フォルダ(暗号化済み) - DB保存用
 */
export interface EncryptedFolder {
  id: string;
  userId: string;
  encryptedName: string;
  nameIv: string;
  nameSalt: string;
  parentFolderId: string | null;
  orderIndex: number;
  createdAt: Date;
  updatedAt: Date;
}

/**
 * フォルダ作成用の入力データ
 */
export interface CreateFolderInput {
  name: string;
  parentFolderId: string | null;
}

/**
 * フォルダ更新用の入力データ
 */
export interface UpdateFolderInput {
  id: string;
  name?: string;
  parentFolderId?: string | null;
  orderIndex?: number;
}

/**
 * フォルダツリーノード
 */
export interface FolderTreeNode {
  folder: Folder;
  children: FolderTreeNode[];
  notes: Note[];
  depth: number;
}
```

#### crypto.ts - 暗号化関連の型

```typescript
// src/types/crypto.ts

/**
 * 暗号化結果
 */
export interface EncryptedData {
  ciphertext: string; // Base64エンコード
  iv: string; // Base64エンコード
  salt: string; // Base64エンコード
}

/**
 * 暗号化パラメータ
 */
export interface EncryptionParams {
  algorithm: 'AES-GCM';
  keyLength: 256;
  ivLength: 12; // bytes
  saltLength: 16; // bytes
  iterations: 600000; // PBKDF2のイテレーション回数
}

/**
 * マスターキー情報
 */
export interface MasterKeyInfo {
  key: CryptoKey;
  derivedFrom: 'password' | 'passkey';
  createdAt: Date;
}

/**
 * リカバリーキー情報
 */
export interface RecoveryKeyInfo {
  mnemonic: string; // 24単語
  hash: string; // サーバー保存用のハッシュ
}
```

#### image.ts - 画像関連の型

```typescript
// src/types/image.ts

/**
 * 画像(復号化済み)
 */
export interface Image {
  id: string;
  userId: string;
  noteId: string;
  filename: string; // 復号化済み
  storagePath: string;
  metadata: ImageMetadata; // 復号化済み
  createdAt: Date;
}

/**
 * 画像(暗号化済み) - DB保存用
 */
export interface EncryptedImage {
  id: string;
  userId: string;
  noteId: string;
  encryptedFilename: string;
  filenameIv: string;
  filenameSalt: string;
  storagePath: string;
  encryptedMetadata: string;
  metadataIv: string;
  metadataSalt: string;
  createdAt: Date;
}

/**
 * 画像メタデータ
 */
export interface ImageMetadata {
  originalFilename: string;
  mimeType: string;
  size: number; // bytes
  width?: number;
  height?: number;
  isOptimized: boolean;
}

/**
 * 画像アップロード用の入力データ
 */
export interface UploadImageInput {
  noteId: string;
  file: File;
  optimize?: boolean;
}
```

#### settings.ts - 設定関連の型

```typescript
// src/types/settings.ts

/**
 * ユーザー設定
 */
export interface UserSettings {
  theme: Theme;
  editorMode: EditorMode;
  sessionTimeout: number; // 分単位
  autoSaveInterval: number; // 秒単位
  imageOptimization: boolean;
  language: Language;
}

/**
 * テーマ
 */
export type Theme = 'light' | 'dark' | 'auto';

/**
 * エディタモード
 */
export type EditorMode = 'edit-preview' | 'realtime';

/**
 * 言語
 */
export type Language = 'ja' | 'en';

/**
 * 暗号化された設定(DB保存用)
 */
export interface EncryptedSettings {
  id: string;
  userId: string;
  encryptedSettings: string;
  iv: string;
  salt: string;
  updatedAt: Date;
}
```

#### database.ts - データベース関連の型

```typescript
// src/types/database.ts

/**
 * Supabase Database型定義
 */
export interface Database {
  public: {
    Tables: {
      users: {
        Row: {
          id: string;
          user_id: string;
          encrypted_master_key: string | null;
          password_hash: string;
          recovery_key_hash: string;
          subscription_tier: 'free' | 'premium' | 'trial';
          subscription_status: 'active' | 'expired' | 'cancelled';
          subscription_started_at: string | null;
          subscription_expires_at: string | null;
          trial_used: boolean;
          storage_used_bytes: number;
          stripe_customer_id: string | null;
          stripe_subscription_id: string | null;
          created_at: string;
          updated_at: string;
        };
        Insert: Omit<Database['public']['Tables']['users']['Row'], 'id' | 'created_at' | 'updated_at'>;
        Update: Partial<Database['public']['Tables']['users']['Insert']>;
      };
      folders: {
        Row: {
          id: string;
          user_id: string;
          encrypted_name: string;
          parent_folder_id: string | null;
          order_index: number;
          created_at: string;
          updated_at: string;
        };
        Insert: Omit<Database['public']['Tables']['folders']['Row'], 'id' | 'created_at' | 'updated_at'>;
        Update: Partial<Database['public']['Tables']['folders']['Insert']>;
      };
      notes: {
        Row: {
          id: string;
          user_id: string;
          folder_id: string | null;
          encrypted_title: string;
          encrypted_content: string;
          encrypted_tags: string;
          order_index: number;
          created_at: string;
          updated_at: string;
          last_synced_at: string | null;
        };
        Insert: Omit<Database['public']['Tables']['notes']['Row'], 'id' | 'created_at' | 'updated_at'>;
        Update: Partial<Database['public']['Tables']['notes']['Insert']>;
      };
      images: {
        Row: {
          id: string;
          user_id: string;
          note_id: string;
          encrypted_filename: string;
          storage_path: string;
          encrypted_metadata: string;
          created_at: string;
        };
        Insert: Omit<Database['public']['Tables']['images']['Row'], 'id' | 'created_at'>;
        Update: Partial<Database['public']['Tables']['images']['Insert']>;
      };
      settings: {
        Row: {
          id: string;
          user_id: string;
          encrypted_settings: string;
          updated_at: string;
        };
        Insert: Omit<Database['public']['Tables']['settings']['Row'], 'id' | 'updated_at'>;
        Update: Partial<Database['public']['Tables']['settings']['Insert']>;
      };
    };
  };
}
```

#### ui.ts - UI状態管理の型

```typescript
// src/types/ui.ts

/**
 * UI全体の状態
 */
export interface UIState {
  sidebarOpen: boolean;
  currentNoteId: string | null;
  currentFolderId: string | null;
  editorMode: EditorMode;
  searchQuery: SearchQuery | null;
  isSearchOpen: boolean;
  theme: Theme;
}

/**
 * トースト通知
 */
export interface Toast {
  id: string;
  type: ToastType;
  message: string;
  duration?: number; // ms
}

/**
 * トースト種類
 */
export type ToastType = 'success' | 'error' | 'warning' | 'info';

/**
 * モーダル状態
 */
export interface ModalState {
  isOpen: boolean;
  type: ModalType | null;
  data?: any;
}

/**
 * モーダル種類
 */
export type ModalType = 
  | 'create-folder'
  | 'rename-folder'
  | 'delete-folder'
  | 'delete-note'
  | 'settings'
  | 'recovery-key';
```

#### api.ts - API関連の型

```typescript
// src/types/api.ts

/**
 * API レスポンス
 */
export interface ApiResponse<T = any> {
  data: T | null;
  error: ApiError | null;
}

/**
 * API エラー
 */
export interface ApiError {
  code: string;
  message: string;
  details?: any;
}

/**
 * ページネーション情報
 */
export interface Pagination {
  page: number;
  pageSize: number;
  totalCount: number;
  totalPages: number;
}

/**
 * ページネーション付きレスポンス
 */
export interface PaginatedResponse<T> {
  data: T[];
  pagination: Pagination;
}
```

---

---

## Phase 1: 実装の優先順位

### 実装スケジュール概要

```
Week 1-2:  Sprint 1 (基盤構築)
Week 3-4:  Sprint 2 (認証機能)
Week 5-6:  Sprint 3-1~3-3 (レイアウト・一覧表示)
Week 7-8:  Sprint 3-4~3-6 (メモ作成・編集・自動保存)
Week 9-10: Sprint 4 (フォルダ管理)
Week 11:   Sprint 5 (検索機能)
Week 12:   Sprint 6 (共通コンポーネント・UX改善)
Week 13:   Sprint 7 (テスト・バグ修正)

合計: 約3ヶ月 (1人で開発の場合)
```

### Sprint 1: 基盤構築 (1-2週間)

**優先度: 最高** - すべての機能の基盤

**1-1. プロジェクトセットアップ**
- Vite + React + TypeScript プロジェクト作成
- Tailwind CSS セットアップ
- ESLint/Prettier 設定
- ディレクトリ構造作成
- 型定義ファイル配置

**1-2. Supabase セットアップ**
- Supabaseプロジェクト作成
- データベーステーブル作成(SQL実行)
- RLSポリシー設定
- Storageバケット作成
- Supabaseクライアント初期化

**1-3. 暗号化ライブラリ実装**
- `lib/crypto/encryption.ts` - encrypt/decrypt関数
- `lib/crypto/keyDerivation.ts` - PBKDF2実装
- `lib/crypto/recoveryKey.ts` - リカバリーキー生成
- テストケース作成(簡易)

**完了条件:**
- [ ] プロジェクトがビルド・起動できる
- [ ] Supabaseに接続できる
- [ ] 暗号化/復号化が動作する

---

### Sprint 2: 認証機能 (1-2週間)

**優先度: 最高** - アプリ利用の前提条件

**2-1. 認証ストア (Zustand)**
- `store/authStore.ts` 実装
- マスターキー管理
- セッション管理

**2-2. 新規登録機能**
- `pages/Signup.tsx`
- `components/auth/SignupForm.tsx`
- ランダムID/パスワード生成
- リカバリーキー生成・表示
- `components/auth/RecoveryKeyDisplay.tsx`

**2-3. ログイン機能**
- `pages/Login.tsx`
- `components/auth/LoginForm.tsx`
- Supabase Auth連携
- マスターキー導出

**2-4. セッション管理**
- SessionManagerクラス実装
- 自動ログアウト(1時間)
- アクティビティ検知によるタイマーリセット

**完了条件:**
- [ ] 新規登録できる
- [ ] リカバリーキーが発行される
- [ ] ログインできる
- [ ] 1時間後に自動ログアウトする

---

### Sprint 3: 基本的なメモ機能 (2週間)

**優先度: 最高** - MVPのコア機能

**3-1. レイアウト構築**
- `components/layout/Layout.tsx`
- `components/layout/Header.tsx`
- サイドバー/メインエリアのレイアウト

**3-2. メモストア**
- `store/notesStore.ts`
- `store/uiStore.ts`
- CRUD操作の状態管理

**3-3. メモ一覧表示**
- `components/sidebar/Sidebar.tsx`
- `components/sidebar/NoteItem.tsx`
- 暗号化データの取得・復号化
- 一覧表示

**3-4. メモ作成**
- 新規メモ作成機能
- タイトル・本文の暗号化
- Supabaseへの保存

**3-5. メモ編集**
- `components/editor/MarkdownEditor.tsx`
- `components/editor/MarkdownPreview.tsx`
- 編集/プレビューモード切り替え
- CodeMirror or Monaco Editor統合

**3-6. 自動保存**
- `hooks/useAutoSave.ts`
- デバウンス処理(2秒)
- 保存状態の表示

**完了条件:**
- [ ] メモを作成できる
- [ ] メモ一覧が表示される
- [ ] メモを編集できる
- [ ] 編集/プレビューを切り替えられる
- [ ] 自動保存される

---

### Sprint 4: フォルダ管理 (1-2週間)

**優先度: 高** - 整理機能として重要

**4-1. フォルダストア**
- `store/foldersStore.ts`
- フォルダツリー構造の管理

**4-2. フォルダ表示**
- `components/sidebar/FolderTree.tsx`
- `components/sidebar/FolderItem.tsx`
- ツリー構造の表示
- 展開/折りたたみ

**4-3. フォルダCRUD**
- フォルダ作成
- フォルダ名変更
- フォルダ削除
- メモのフォルダ移動(手動、ドラッグ&ドロップなし)

**完了条件:**
- [ ] フォルダを作成できる
- [ ] フォルダツリーが表示される
- [ ] メモをフォルダに移動できる
- [ ] フォルダを削除できる

---

### Sprint 5: 検索機能(基本) (1週間)

**優先度: 中** - Phase 1の最低限の検索

**5-1. ファイル名検索**
- `components/sidebar/SearchBar.tsx`
- タイトルでの検索(復号化後)
- 検索結果表示

**5-2. 検索UI**
- 検索バーの配置
- 検索結果のフィルタリング表示

**完了条件:**
- [ ] ファイル名で検索できる
- [ ] 検索結果が表示される

---

### Sprint 6: 共通コンポーネント・UX改善 (1週間)

**優先度: 中** - UX向上

**6-1. 共通コンポーネント**
- `components/common/Button.tsx`
- `components/common/Input.tsx`
- `components/common/Modal.tsx`
- `components/common/Loading.tsx`
- トースト通知システム

**6-2. エラーハンドリング**
- エラークラスの実装
- グローバルエラーハンドリング
- ユーザーへのエラー表示

**6-3. ローディング状態**
- スケルトンローダー
- ローディングスピナー

**完了条件:**
- [ ] エラーが適切に表示される
- [ ] ローディング状態が表示される
- [ ] トースト通知が動作する

---

### Sprint 7: テスト・バグ修正 (1週間)

**優先度: 高** - リリース前の必須作業

**7-1. 手動テスト**
- 全機能の動作確認
- エッジケースのテスト
- ブラウザ互換性確認

**7-2. バグ修正**
- 発見されたバグの修正
- パフォーマンス改善

**7-3. ドキュメント**
- README作成
- 環境構築手順
- デプロイ手順

**完了条件:**
- [ ] すべての機能が正常に動作する
- [ ] 主要なバグが修正されている
- [ ] デプロイ可能な状態

---

## Phase 1 実装チェックリスト

### Sprint 1: 基盤構築
- [ ] プロジェクトセットアップ
- [ ] Supabaseセットアップ
- [ ] 暗号化ライブラリ実装

### Sprint 2: 認証
- [ ] 認証ストア
- [ ] 新規登録
- [ ] ログイン
- [ ] セッション管理

### Sprint 3: メモ機能
- [ ] レイアウト
- [ ] メモストア
- [ ] メモ一覧
- [ ] メモ作成
- [ ] メモ編集
- [ ] 自動保存

### Sprint 4: フォルダ
- [ ] フォルダストア
- [ ] フォルダ表示
- [ ] フォルダCRUD

### Sprint 5: 検索
- [ ] ファイル名検索
- [ ] 検索UI

### Sprint 6: UX
- [ ] 共通コンポーネント
- [ ] エラーハンドリング
- [ ] ローディング

### Sprint 7: テスト
- [ ] 手動テスト
- [ ] バグ修正
- [ ] ドキュメント

---

## 次のステップ

1. ✅ プロダクト名を決める → **Kaname**
2. ✅ デザイン方向性を決める
3. ✅ データベーススキーマ設計
4. ✅ Phase 1の詳細な技術設計
5. ✅ 型定義の作成
6. ✅ 実装の優先順位決定
7. Phase 1の実装開始 (Sprint 1から)