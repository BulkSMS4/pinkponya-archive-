# Pinkponya Archive Fan Community Website

A responsive React + TypeScript + Vite starter site with a fan registration form, photo gallery, video gallery with category filters/search/load-more, about/disclaimer section, and admin dashboard interface.

## Important before publishing

- This is an **independent fan page**, not the official Pinkponya Archive account. Use only photos and video links you have permission to publish.
- The gallery starts with sample stock images and placeholder video cards. These are **not actual Pinkponya Archive media**. Replace them with your own authorized images and valid video links.
- The site can run immediately in **preview mode**. In preview mode, registrations are stored only in the current browser and are not shared across devices. The sample gallery changes are also saved only in that browser.
- To collect real registrations securely across devices, connect a Supabase project using the steps below. The supplied SQL schema enables public registration inserts while restricting registration reads to authorized admin users.
- The admin interface's registration list uses Supabase when configured. Photo/video management currently stores content in the browser's local storage as a starter interface; for a production CMS shared between devices, wire these forms to the included `photo_gallery` and `video_gallery` tables and Supabase Storage.
- Before launch, publish a full privacy policy and verify the legal requirements for your audience and where you operate.

## Run locally

1. Install Node.js (current LTS).
2. Extract the ZIP file.
3. Open a terminal in the extracted `pinkponya_archive_site` folder.
4. Run:

   ```bash
   npm install
   npm run dev
   ```

5. Open the local URL shown in the terminal (typically `http://localhost:5173`).

To create a production build:

```bash
npm run build
npm run preview
```

## Connect Supabase for real registrations

1. Create a project at https://supabase.com/.
2. In the Supabase SQL Editor, run `supabase/schema.sql`.
3. Copy `.env.example` to a new file named `.env`.
4. Add your Supabase project URL and **public anon/publishable key** to `.env`:

   ```env
   VITE_SUPABASE_URL=https://YOUR-PROJECT.supabase.co
   VITE_SUPABASE_ANON_KEY=YOUR_PUBLIC_ANON_KEY
   ```

5. Restart the Vite server after changing `.env`.
6. In Supabase Authentication, create the admin user privately. Assign `app_metadata.role = "admin"` through a trusted server-side/admin workflow. Do not allow users to assign themselves the admin role.
7. Enable email confirmation and set appropriate password/security policies before launch.

**Never put a Supabase service-role key in browser code, in a `VITE_*` variable, or in this ZIP.** Only use the public anon/publishable key in the browser. The database Row Level Security policies protect registration data.

## Update photos and videos

- Open the site, scroll to the footer, and choose **Admin**.
- With Supabase configured, sign in using the authorized admin user to view registrations and export CSV.
- The starter Photos and Videos management screens accept URLs and persist changes in that browser only. For a shared production content system, connect them to the `photo_gallery` and `video_gallery` tables and configure Supabase Storage policies for file uploads.
- For YouTube, use a standard link such as `https://www.youtube.com/watch?v=VIDEO_ID`. Vimeo links are also supported.
- Use accessible public image URLs for thumbnails and photos until image upload/storage is implemented.

## What is included

- Mobile-responsive design with dark, pink, white, and purple styling
- Fan registration fields: name, email, country, city, phone, optional WhatsApp, optional Instagram, event location, event interest
- Separate optional email and WhatsApp marketing opt-ins, unchecked by default
- Required privacy acknowledgment
- Success/error feedback on form submission
- Photo gallery with click-to-expand lightbox
- Video gallery with 12 starter cards, search, categories, playback modal, and load-more batches
- Admin registration view, search, opt-in counts, CSV export, and deletion action
- Fan-page disclaimer and contact email: pinkponyaarchive@gmail.com

## Before you publish

Replace the generic Instagram/Facebook/YouTube links with your actual fan-page URLs; replace the sample images; add real authorized videos; complete the shared gallery CMS integration; write a complete privacy policy and terms; test form submissions, admin access, CSV export, mobile layouts, and data deletion; then deploy to a host such as Vercel or Netlify.
