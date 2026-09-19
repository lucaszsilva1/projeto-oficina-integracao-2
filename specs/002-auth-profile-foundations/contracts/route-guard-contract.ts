/**
 * Contrato de Proteção de Rotas (Route Guard)
 * Módulo: @ellp/auth
 * Feature: 002-auth-profile-foundations
 */

import { UserRole } from './auth-contract';

export interface RouteProtectionConfig {
  publicRoutes: string[];
  protectedStudentRoutes: string[];
  protectedAdminRoutes: string[];
  loginRoute: string;
  defaultStudentRedirect: string;
  defaultAdminRedirect: string;
}

export const DEFAULT_ROUTE_CONFIG: RouteProtectionConfig = {
  publicRoutes: ['/', '/login', '/auth/callback'],
  protectedStudentRoutes: ['/workspace', '/workspace/.*'],
  protectedAdminRoutes: ['/admin', '/admin/.*'],
  loginRoute: '/login',
  defaultStudentRedirect: '/workspace',
  defaultAdminRedirect: '/admin',
};

export type RouteAccessDecision =
  | { action: 'ALLOW' }
  | { action: 'REDIRECT'; destination: string; reason: 'UNAUTHENTICATED' | 'ALREADY_AUTHENTICATED' | 'FORBIDDEN' };

/**
 * Função pura de decisão de acesso a rotas
 * Respeita a Seção 5 da Constituição (Domain -> sem acoplamento a objetos HTTP ou Request)
 */
export function evaluateRouteAccess(
  pathname: string,
  session: { isAuthenticated: boolean; role?: UserRole } | null,
  config: RouteProtectionConfig = DEFAULT_ROUTE_CONFIG
): RouteAccessDecision {
  const isPublic = config.publicRoutes.some((route) => pathname === route);
  const isAdminRoute = config.protectedAdminRoutes.some((pattern) => new RegExp(`^${pattern}$`).test(pathname));
  const isStudentRoute = config.protectedStudentRoutes.some((pattern) => new RegExp(`^${pattern}$`).test(pathname));
  const isLoginRoute = pathname === config.loginRoute;

  // 1. Visitante não autenticado tentando acessar rotas privadas
  if (!session || !session.isAuthenticated) {
    if (isAdminRoute || isStudentRoute) {
      const redirectUrl = `${config.loginRoute}?redirectTo=${encodeURIComponent(pathname)}`;
      return { action: 'REDIRECT', destination: redirectUrl, reason: 'UNAUTHENTICATED' };
    }
    return { action: 'ALLOW' };
  }

  // 2. Usuário autenticado acessando a tela de login
  if (isLoginRoute) {
    const destination = session.role === 'admin' ? config.defaultAdminRedirect : config.defaultStudentRedirect;
    return { action: 'REDIRECT', destination, reason: 'ALREADY_AUTHENTICATED' };
  }

  // 3. Usuário autenticado acessando rotas de administração
  if (isAdminRoute) {
    if (session.role !== 'admin') {
      return { action: 'REDIRECT', destination: config.defaultStudentRedirect, reason: 'FORBIDDEN' };
    }
    return { action: 'ALLOW' };
  }

  // 4. Usuário autenticado acessando rotas de estudante/workspace ou públicas
  return { action: 'ALLOW' };
}
