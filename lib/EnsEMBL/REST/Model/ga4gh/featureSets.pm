=head1 LICENSE
Copyright [1999-2014] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
     http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
=cut

package EnsEMBL::REST::Model::ga4gh::featureSets;

use Moose;
extends 'Catalyst::Model';
use Catalyst::Exception;

use Scalar::Util qw/weaken/;

use EnsEMBL::REST::Model::ga4gh::ga4gh_utils;
with 'Catalyst::Component::InstancePerContext';

has 'context' => (is => 'ro');

## referenceSetId is currently the metadata assembly.name 

sub build_per_context_instance {
  my ($self, $c, @args) = @_;
  weaken($c);
  return $self->new({ context => $c, %$self, @args });
}

## POST entry point
sub searchFeatureSets {
  
  my $self   = shift;
  my $data   = shift;

  ## only supporting one dataset currently
  return { featureSets   => [],
           nextPageToken => undef
         } unless $data->{datasetId} eq 'Ensembl';


  my $featureSet = $self->context->model('ga4gh::ga4gh_utils')->fetch_featureSet();

  return { featureSets   => [$featureSet],
           nextPageToken => undef
         }; 
}

## GET entry point
sub getFeatureSet{

  my ($self, $id ) = @_; 

  ## only one feature set supported
  my $featureSet = $self->context->model('ga4gh::ga4gh_utils')->fetch_featureSet();

  ## check id
  return {} unless $id eq 'Ensembl' || $id eq $featureSet->{id};
  
  return $featureSet;

}


1;
