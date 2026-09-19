import type { Metadata } from 'next';
import React from 'react';

export const metadata: Metadata = {
  title: 'ELLP - Plataforma Educativa de Programação em Blocos',
  description: 'Projeto de extensão universitária UTFPR para ensino de lógica e programação em blocos.',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="pt-BR">
      <body>{children}</body>
    </html>
  );
}
