package CGI::Wiki::Formatter::Kwiki;

use strict;

use vars qw( $VERSION @_links_found );
$VERSION = '0.03';

use CGI ":standard";
use Carp qw(croak carp);

use CGI::Kwiki::Formatter;
use base qw(CGI::Kwiki::Formatter);

=head1 NAME

CGI::Wiki::Formatter::Kwiki - A Kwiki formatter for CGI::Wiki.

=head1 DESCRIPTION

A formatter backend for L<CGI::Wiki>.

It wraps the Formatter module from CGI::Kwiki, 
=head1 SYNOPSIS

  my $store     = CGI::Wiki::Store::SQLite->new( ... );
  # See below for parameter details.
  my $formatter = CGI::Wiki::Formatter::Kwiki->new( %config );
  my $wiki      = CGI::Wiki->new( store     => $store,
                                  formatter => $formatter );

=head1 METHODS

=over 4

=item B<new>

  my $formatter = CGI::Wiki::Formatter::Kwiki->new(
	         node_prefix     => 'wiki.cgi?node='
	     );

=back

=cut

sub new {
    my ($class, @args) = @_;
    my $self = {};
    bless $self, $class;
    $self->_init(@args) or return undef;
    return $self;
}

sub _init {
    my ($self, %args) = @_;

    # Store the parameters or their defaults.
    my %defs = (    node_prefix     => 'wiki.cgi?node=', );

    my %collated = (%defs, %args);
    foreach my $k (keys %defs) {
        $self->{"_".$k} = $collated{$k};
    }

    return $self;
}

=item B<format>

  my $html = $formatter->format( $content );

Calls Kwiki::Formatter->process on the content (with some slight changes
to allow for the fact that it's not in the context of a Kwiki.

=cut

sub format {
    my ($self, $raw) = @_;
    return $self->process($raw);
}

=item B<find_internal_links>

  my @links_to = $formatter->find_internal_links( $content );

Returns a list of all nodes that the supplied content links to.

=cut

sub find_internal_links {
    my ($self, $raw) = @_;
    $self->{links} = {};
    $self->process($raw);
    return keys(%{$self->{links}});

}

=back

=head1 SEE ALSO

L<CGI::Wiki>, L<CGI::Kwiki>

=head1 AUTHOR

Tom Insam (tom@jerakeen.org)

=head1 CREDITS

Thanks to Kake for writing CGI::Wiki in the first place, and davorg for giving
me a nice lumpy data-set to test things on. And I have to credit whomever came
up with this markup language, I suppose. Hi.

=head1 COPYRIGHT

     Copyright (C) 2003 Tom Insam.  All Rights Reserved.

This module is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut




sub wiki_link_format {
    my ($self, $text) = @_;
    my $wiki_link = qq{<a href="$self->{_node_prefix}$text">$text</a>};
    $self->{links}{lc($text)}++;
    return $wiki_link;
}

sub process {
    my ($self, $wiki_text) = @_;
    my $array = [];
    push @$array, $wiki_text;

#    print STDERR "start:\n".$self->combine_chunks($array)."\n\n\n\n\n----------\n";

    for my $method ($self->process_order) {
        $array = $self->dispatch($array, $method);
#        print STDERR "$method:\n".$self->combine_chunks($array)."\n\n\n\n\n----------\n";
    }
    return $self->combine_chunks($array);
}

#        function
#        table code 

sub process_order {
    return qw(
        header_1 header_2 header_3 header_4 header_5 header_6 
        escape_html
        lists horizontal_line
        paragraph 
        named_http_link no_http_link http_link
        no_mailto_link mailto_link
        no_wiki_link force_wiki_link wiki_link
        inline version negation
        bold italic underscore
    );
}

1;
