"""
MkDocs macros for fada documentation
"""
import yaml
import os

def define_env(env):
    """Define macros for MkDocs"""
    
    @env.macro
    def hydra_modules():
        """Get module versions from config.yaml and generate markdown list"""
        config_path = os.path.join(env.project_dir, "config", "config.yaml")
        
        try:
            with open(config_path, 'r') as f:
                config = yaml.safe_load(f)
        except FileNotFoundError:
            return "Error: config.yaml not found"
        except yaml.YAMLError:
            return "Error: Could not parse config.yaml"
        
        modules = config.get('modules', {})
        
        # Module descriptions
        descriptions = {
            'alignment': 'Read alignment and mapping tools',
            'annotation': 'Variant annotation and functional analysis',
            'compression': 'File compression and format conversion',
            'cnv_sv': 'Copy number variant and structural variant detection',
            'filtering': 'Variant filtering and quality control',
            'misc': 'Miscellaneous utilities and helper functions',
            'prealignment': 'Pre-processing and quality control of raw reads',
            'qc': 'Quality control metrics and reporting',
            'reports': 'Report generation and visualization',
            'snv_indels': 'Small variant (SNV/indel) detection and genotyping'
        }
        
        output = []
        for module, version in sorted(modules.items()):
            desc = descriptions.get(module, f'{module} module')
            url = f"https://github.com/hydra-genetics/{module}"
            output.append(f"- **[{module} {version}]({url})**: {desc}")
        
        return '\n'.join(output)