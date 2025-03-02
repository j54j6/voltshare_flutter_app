abstract class NavbarEvent {
  //extends Equatable
  //@override
  List<Object?> get props => [];
}

class NavbarItemTappedEvent extends NavbarEvent {
  final int index;

  NavbarItemTappedEvent(this.index);

  @override
  List<Object?> get props => [index];
}

class UpdateNavbarAuthStateEvent extends NavbarEvent {
  final bool isAuthenticated;

  UpdateNavbarAuthStateEvent(this.isAuthenticated);

  @override
  List<Object?> get props => [isAuthenticated];
}
