/**
 * Contratos de Autenticação e Perfis
 * Módulo: @ellp/auth
 * Feature: 002-auth-profile-foundations
 */

export type UserRole = 'admin' | 'student';

export interface UserProfile {
  id: string; // UUID correspondente a auth.users(id)
  email: string;
  fullName: string;
  avatarUrl: string | null;
  role: UserRole;
  createdAt: string; // ISO 8601
  updatedAt: string; // ISO 8601
}

export interface AuthSession {
  user: {
    id: string;
    email: string;
  };
  profile: UserProfile;
  accessToken: string;
  expiresAt: number;
}

export interface UpdateProfileDTO {
  fullName?: string;
  avatarUrl?: string | null;
}

export interface ActionResult<T = void> {
  success: boolean;
  data?: T;
  error?: {
    code: 'UNAUTHENTICATED' | 'FORBIDDEN' | 'NOT_FOUND' | 'VALIDATION_ERROR' | 'INTERNAL_ERROR';
    message: string;
  };
}

/**
 * Interface do repositório de perfis (Data Access Layer)
 * Respeita a Seção 4 da Constituição: não decide regras de negócio.
 */
export interface IProfileRepository {
  getById(id: string): Promise<UserProfile | null>;
  getByEmail(email: string): Promise<UserProfile | null>;
  listStudents(): Promise<UserProfile[]>;
  update(id: string, data: UpdateProfileDTO): Promise<UserProfile>;
  updateRole(id: string, role: UserRole): Promise<UserProfile>;
  deleteStudent(id: string): Promise<boolean>;
}

/**
 * Interface dos Casos de Uso (Application Layer)
 */
export interface IAuthService {
  getCurrentSession(): Promise<AuthSession | null>;
  signInWithGoogle(): Promise<{ url: string }>;
  signOut(): Promise<void>;
}

export interface IAdminStudentService {
  listAllStudents(): Promise<UserProfile[]>;
  deleteStudentProfile(studentId: string, currentAdminId: string): Promise<ActionResult>;
}
