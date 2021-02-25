%define LIBNAME mdsplib
Summary: mdsplib library
Name: %{LIBNAME}
Version: 21.2.25
Release: 1%{?dist}.fmi
License: GNU
Group: Development/Libraries
URL: https://github.com/flightaware/mdsplib
Source0: %{name}.tar.gz
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-buildroot-%(%{__id_u} -n)
Provides: %{LIBNAME} metar

%description
METAR Decoder Software Package Library

%prep
rm -rf $RPM_BUILD_ROOT

%setup -q -n %{name}
cd $HOME/hub/mdsplib
 
%build
make %{_smp_mflags}

%install
%makeinstall

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,0775)
%{_includedir}/metar.h
%{_includedir}/metar_structs.h
%{_includedir}/local.h
%{_libdir}/libmetar.a

%changelog
* Thu Feb 25 2021 Pertti Kinnia <pertti.kinnia@fmi.fi> - 21.2.25-1.fmi
- Changed (loosened) visibility value ranges/precisions when parsing messages (QDTOOLS-94)
* Wed Aug 26 2020 Mika Heiskanen <mika.heiskanen@fmi.fi> - 20.8.26-1.fmi
- Pulled latest version
* Sat Apr  8 2017 Mika Heiskanen <mika.heiskanen@fmi.fi> - 16.4.8-1.fmi
- Packaged from GitHub

