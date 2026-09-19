/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  transpilePackages: ['@ellp/auth', '@ellp/database'],
};

export default nextConfig;
