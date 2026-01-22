import shutil

def copy_changelog_and_license(*args, **kwargs):
    #shutil.copy("CHANGELOG.md", "docs/changelog.md")
    shutil.copy("LICENSE.md", "docs/license.md")
    # shutil.copy("config/config.yaml", "docs/includes/config.yaml")
    # shutil.copy("config/resources.yaml", "docs/includes/resources.yaml")
    shutil.copy("images/pb_twist_cancer_rulegraph.png", "docs/includes/images/pb_twist_cancer_rulegraph.png")